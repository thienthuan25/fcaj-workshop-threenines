---
title : "Triển khai Lambda Analyzer"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.4.2 </b> "
---

#### Bổ sung biến cấu hình cho Analyzer

Analyzer cần hai biến để phục vụ logic phát hiện tăng đột biến. Chúng ta cần bổ sung hai biến sau vào `variables.tf`:

```hcl
# Hệ số nhân dùng để nhận diện sự gia tăng chi phí bất thường. So sánh chi phí hiện tại với chi phí trung bình trong quá khứ nhân với hệ số này
variable "spike_multiplier" {
  description = "Spike multiplier: if cost > historical average * this multiplier, it is considered an abnormal spike"
  type        = number
  default     = 1.5 # chi phí hiện tại vượt mức 1.5 lần trung bình thì sẽ cảnh báo.
}

# Số ngày trong quá khứ được lấy ra làm mốc để tính
variable "history_days" {
  description = "Number of historical days used to calculate the average cost (for spike detection)"
  type        = number
  default     = 7 # tính trung bình chi phí của 7 ngày gần nhất
}
```

#### Viết code Lambda Analyzer

Chúng ta sẽ tạo file `lambda/analyzer/handler.py` chứa mã nguồn python của  hàm Lambda Analyzer.

Hàm này tự động kích hoạt mỗi khi nhận được tin nhắn báo cáo từ hàng đợi SQS (do Collector gửi sang). Quá trình xử lý diễn ra theo 3 bước:

1. **Truy xuất dữ liệu**: Nó lấy đường dẫn file từ tin nhắn SQS, sau đó tiến hành lấy chi phí từ kho lưu trữ từ S3 về để đọc.
2. **Đánh giá thông minh**: Hàm sẽ tính tổng chi phí trong ngày và liệt kê top 5 dịch vụ tốn kém nhất. Nâng cao hơn, hàm còn tự động đọc lại các file cũ trên S3 để tính ra mức chi phí trung bình trong 7 ngày gần nhất.
3. **Ra quyết đinh cảnh báo**: Nó sẽ đối chiếu chi phí hiện tại với hai điều kiện:

- Có vượt giới hạn ngân sách cố định không?
- Có tăng vọt bất thường so với mức trung bình lịch sử không?

    Nếu có bất cứ điều kiện nào được thỏa mãn thì nó sẽ gửi cảnh báo chi tiết qua Email đến người dùng.

```python
""" 
Chức năng: 
    1. Được kích hoạt bởi sự kiện từ SQS (do Collector gửi)
    2. Đọc dữ liệu chi phí tương ứng từ S3
    3. So sánh tổng chi phí với ngưỡng ngân sách (threshold) + phát hiện bất thường
        (tăng đột biến so với mức trung bình lịch sử - nếu có)
    4. Nếu vượt ngưỡng / bất thường -> gửi cảnh báo qua SNS

Sự kiện xử lý lỗi sẽ được SQS tự động chuyển vào DLQ (theo redrive policy)
"""

import boto3
import os
import json
import boto3
from datetime import datetime, timedelta

# Đọc cấu hình từ biến môi trường (Terraform truyền vào)
BUCKET_NAME = os.environ["BUCKET_NAME"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]
COST_THRESHOLD = float(os.environ.get("COST_THRESHOLD_USD", "10"))

# Hệ số tăng đột biến: chi phí > trung bình * hệ số này  => bất thường
SPIKE_MULTIPLIER = float(os.environ.get("SPIKE_MULTIPLIER", "1.5"))
# Số ngày lịch sử dùng để tính trung bình
HISTORY_DAYS = int(os.environ.get("HISTORY_DAYS", "7"))

s3_client = boto3.client("s3")
sns_client = boto3.client("sns")

def read_cost_from_s3(s3_key: str) -> dict:
    # Đọc file dữ liệu chi phí (.json) từ S3
    response = s3_client.get_object(Bucket = BUCKET_NAME, Key = s3_key)
    return json.loads(response["Body"].read())

def compute_total_and_top(cost_data: dict) -> dict:
    """Tính tổng chi phí + top dịch vụ tốn nhất từ dữ liệu Cost Explorer."""
    total_cost = 0.0
    service_costs = {}
    for result in cost_data.get("ResultsByTime", []):
        for group in result.get("Groups", []):
            service = group["Keys"][0]
            amount = float(group["Metrics"]["UnblendedCost"]["Amount"])
            service_costs[service] = service_costs.get(service, 0.0) + amount
            total_cost += amount
    top_services = sorted(service_costs.items(), key=lambda x: x[1], reverse=True)[:5]
    return {"total_cost": round(total_cost, 4), "top_services": top_services}

def get_historical_average(current_date: str) -> float:
    # Tính chi phí trung bình của HISTORY_DAYS ngày trước trước ngày hiện tại,
    # đọc từ các file đã luuw trong S3. Trả về 0 nếu chưa có lịch sử
    dt = datetime.strptime(current_date, "%Y-%m-%d")
    totals = []
    for i in range(1, HISTORY_DAYS + 1):
        day = dt - timedelta(days = i)
        key = f"cost-data/year={day.year}/month={day.month:02d}/day={day.day:02d}/cost_{day.strftime('%Y-%m-%d')}.json"
        try:
            data = read_cost_from_s3(key)
            totals.append(compute_total_and_top(data)["total_cost"])
        except s3_client.exceptions.NoSuchKey:
            continue
        except Exception:
            continue
    if not totals:
        return 0.0
    return round(sum(totals) / len(totals), 4)

def classify_severity(total: float, avg: float) -> tuple:
    # Phân loại mức độ cảnh báo dựa trên ngưỡng cố định và tăng đột biến.
    # trả về (severity, reasons[])

    reasons = []
    severity = "INFO"

    # vượt ngưỡng ngân sách
    if total > COST_THRESHOLD:
        reasons.append(f"Budget threshold exceeded (${COST_THRESHOLD:.2f})")
        severity = "WARNING"

    # tăng đột biến so với trung bình lịch sử
    if avg > 0 and total > avg * SPIKE_MULTIPLIER:
        pct = ((total - avg) / avg) * 100
        reasons.append(f"Cost spike detected: {pct:.0f}% above historical average {HISTORY_DAYS} day (${avg:.2f})")
        severity = "CRITICAL"
    
    return severity, reasons


def send_alert(date_str: str, analysis: dict, severity: str, reasons: list, avg: float) -> None:
    # Gửi cảnh báo qua SNS khi chi phí vượt ngưỡng
    total = analysis["total_cost"]

    lines = [
        f"[{severity}] AWS COST ALERT - CloudCost Insight",
        "",
        f"Day: {date_str}",
        f"Total cost: ${total:.2f}",
        f"Alert threshold: ${COST_THRESHOLD:.2f}",
        f"Historical average ({HISTORY_DAYS} days): ${avg:.2f}",
        "",
        "Reasons:"
    ]
    for r in reasons:
        lines.append(f" - {r}")
        
    lines.extend([
        "",
        "Top Service by cost:"
    ])
    
    for service, cost in analysis["top_services"]:
        lines.append(f" - {service}: ${cost:.2f}")

    message = "\n".join(lines)

    sns_client.publish(
        TopicArn = SNS_TOPIC_ARN,
        Subject = f"[{severity}] CloudCost Insight Alert for {date_str}",
        Message = message,
    )

def lambda_handler(event, context):
    """Điểm vào — được SQS kích hoạt. Mỗi record là 1 sự kiện từ Collector."""
    processed = 0

    for record in event.get("Records", []):
        body = json.loads(record["body"])
        date_str = body["date"]
        s3_key = body["s3_key"]

        print(f"[Analyzer] Processing cost data for date {date_str} (key={s3_key})")

        # 1. Đọc dữ liệu chi phí ngày hiện tại
        cost_data = read_cost_from_s3(s3_key)
        analysis = compute_total_and_top(cost_data)
        total = analysis["total_cost"]

        # 2. Tính trung bình lịch sử để phát hiện tăng đột biến
        avg = get_historical_average(date_str)
        print(f"[Analyzer] Total: ${total:.2f} | Average {HISTORY_DAYS} Day: ${avg:.2f} | Threshold: ${COST_THRESHOLD:.2f}")

        # 3. Phân loại mức độ & quyết định cảnh báo
        severity, reasons = classify_severity(total, avg)
        if reasons:
            print(f"[Analyzer] {severity}! Reason: {reasons}. Send alert to SNS.")
            send_alert(date_str, analysis, severity, reasons, avg)
        else:
            print(f"[Analyzer] Normal cost, no need to alert.")

        processed += 1

    return {"statusCode": 200, "processed": processed}
```

#### Cấu hình IAM Role và triển khai Analyzer

Tiếp theo, chúng ta sẽ tạo file `lambda/lambda_analyzer.tf`. File này chịu trách nhiệm xây dựng toàn bộ cơ sở hạ tầng cần thiết trên AWS để chạy hàm Lambda Analyzer, thực hiện các cấu hình tự động bao gồm:

1. **Cấp quyền bảo mật**: Tạo các quyền đặc biệt cho phép hàm Analyzer được phép đọc dữ liệu từ kho lưu trữ S3, lấy tin nhắn từ hàng đợi SQS và gửi cảnh báo qua dịch vụ SNS.
2. **Đóng gói và triển khai**: Tự động nén mã nguồn Python thành file zip và tải lên nền tảng AWS để tạo thành một hàm thực thi hoàn chỉnh.
3. **Liên kết tự động**: Thiết lập một luồng kết nối trực tiếp từ hàng đợi SQS tới hàm Analyzer. Cứ mỗi khi có một thông báo mới về chi phí xuất hiện trong hàng đợi, hệ thống sẽ tự động kích hoạt hàm Analyzer để xử lý.

Nếu chỉ có mã nguồn Python thì hệ thống sẽ không biết phải chạy đoạn mã đó như thế nào và lấy quyền truy cập từ đâu. Do đó, file cấu hình Terraform này giúp kết nối các thành phần rời rạc gồm **S3**, **SQS**, **SNS**, và **Lambda** lại với nhau thành một dây chuyền tự động và hoàn toàn khép kín.

```hcl
# IAM role cho Analyzer 
resource "aws_iam_role" "analyzer" {
  name               = "${var.project_name}-analyzer-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json     # Khai báo dịch vụ Lambda được phép sử dụng quyền này.
}

# Cho phép đọc file dữ liệu chi phí đã lưu từ s3
data "aws_iam_policy_document" "analyzer_policy" {
  statement {
    sid       = "S3ReadCostData"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cost_data.arn}/*"]
  }

  # Cho phép xem các file trong S3 Bucket.
  statement {
    sid       = "S3ListBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.cost_data.arn]
  }

  # nhận & xóa message từ SQS chính 
  statement {
    sid    = "SQSConsume"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [aws_sqs_queue.events.arn]
  }

  # publish cảnh báo qua SNS
  statement {
    sid       = "SNSPublish"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.cost_alerts.arn]
  }

  # ghi log lên CloudWatch
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# Gán Policy vào IAM role của Analyzer.
resource "aws_iam_role_policy" "analyzer" {
  name   = "${var.project_name}-analyzer-policy"
  role   = aws_iam_role.analyzer.id
  policy = data.aws_iam_policy_document.analyzer_policy.json
}

# Đóng gói code
data "archive_file" "analyzer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/analyzer"
  output_path = "${path.module}/build/analyzer.zip"
}

# Tạo Log Group cho Analyzer
resource "aws_cloudwatch_log_group" "analyzer" {
  name              = "/aws/lambda/${var.project_name}-analyzer"
  retention_in_days = 14
}

# Hàm Lambda Analyzer.
resource "aws_lambda_function" "analyzer" {
  function_name = "${var.project_name}-analyzer"
  role          = aws_iam_role.analyzer.arn  # gán role
  handler       = "handler.lambda_handler"   # chỉ định nơi chạy code chính
  runtime       = "python3.12"               # chỉ định phiên bản python
  timeout       = 60                         # thời gian tối đa
  memory_size   = 128                        # bộ nhớ

  filename         = data.archive_file.analyzer_zip.output_path
  source_code_hash = data.archive_file.analyzer_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME        = aws_s3_bucket.cost_data.id       # Đưa tên S3 vào biến môi trường
      SNS_TOPIC_ARN      = aws_sns_topic.cost_alerts.arn    # Đưa ARN của SNS vào biến môi trường
      COST_THRESHOLD_USD = var.cost_threshold_usd           # Đưa mức ngưỡng chi phí vào biến môi trường
      SPIKE_MULTIPLIER   = var.spike_multiplier             # Đưa hệ số tăng đột biến vào biến môi trường
      HISTORY_DAYS       = var.history_days                 # Đưa số ngày để tính trung bình vào biến môi trường
    }
  }

  depends_on = [aws_cloudwatch_log_group.analyzer]          # Đợi Log Group tạo xong mới tạo hàm
}

# Tự động kích hoạt Lambda Analyzer khi có tin nhắn mới rơi vào SQS Queue
resource "aws_lambda_event_source_mapping" "sqs_to_analyzer" {
  event_source_arn = aws_sqs_queue.events.arn           # Chỉ định nguồn kích hoạt là SQS Queue
  function_name    = aws_lambda_function.analyzer.arn   # Chỉ định hàm Lambda cần kích hoạt
  batch_size       = 10                                 # Gom tối đa 10 tin nhắn xử lý trong 1 lần gọi hàm
  enabled          = true                               # Bật trạng thái hoạt động ngay lập tức
}
```

#### Nội dung tiếp theo

- [Giám sát](5-Workshop/5.5-Monitoring/)
