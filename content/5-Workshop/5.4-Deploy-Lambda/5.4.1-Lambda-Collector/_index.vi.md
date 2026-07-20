---
title : "Triển khai Lambda Collector"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.4.1 </b> "
---

#### Viết Code Lambda Collector

Chúng ta sẽ tạo file `lambda/collector/handler.py`. File này đóng vai trò là bộ phận thu thập dữ liệu chính của toàn bộ hệ thống **CloudCost Insight**.

Mỗi khi được EventBridge kích hoạt tự động mỗi ngày, hàm này sẽ thực hiện một luồng ba bước:

1. **Lấy dữ liệu**: Gọi API của dịch vụ AWS Cost Explorer để xuất báo cáo chi tiết về mọi khoản chi phí phát sinh trong ngày hôm qua và phân loại theo từng dịch vụ.
2. **Lưu trữ**: Đưa toàn bộ dữ liệu vừa lấy được để lưu trữ an toàn vào S3 Bucket, đồng thời tự động phân chia thư mục gọn gàng theo thời gian theo ngày/tháng/năm.
3. **Kích hoạt xử lý**: Sau khi lưu xong, hàm sẽ tính tổng số tiền đã tiêu, đóng gói thông tin đó cùng với đường dẫn file trên S3 thành một sự kiện rồi gửi vào hàng đợi SQS để ra lệnh cho Lambda Analyzer bắt đầu làm việc.

Việc thu thập dữ liệu và phân tích dữ liệu được phân tách ra giúp cho hệ thông khi gặp lỗi vẫn giữ được dữ liệu gốc một cách an toàn và nguyên vẹn trên S3.

```python
"""
Lambda Collector - CloudCost Insight
Chức năng:
 1. Gọi AWS Cost Explorer API để lấy dữ liệu chi phí (ngày hôm qua)
 2. Ghi dữ liệu thô vào S3 (phân vùng theo năm/tháng/ngày)
 3. Đẩy một sự kiện vào SQS để Lambda Analyzer xử lý

Được kích hoạt định kỳ bởi EventBridge (mặc định 1 lần/ngày)
"""

import boto3
import os
import json
import boto3
from datetime import datetime, timedelta

# Đọc cấu hình từ biến môi trường
BUCKET_NAME = os.environ["BUCKET_NAME"]
QUEUE_URL = os.environ["QUEUE_URL"]

# Khởi tạo Client AWS
ce_client = boto3.client("ce")
s3_client = boto3.client("s3")
sqs_client = boto3.client("sqs")

def get_cost_data(start_date: str, end_date: str) -> dict:
    # Gọi Cost Explorer API lấy chi phí theo dịch vụ trong khoảng ngày
    response = ce_client.get_cost_and_usage(
        TimePeriod = {"Start": start_date, "End": end_date},
        Granularity = "DAILY",
        Metrics = ["UnblendedCost"],
        GroupBy = [
            {"Type": "DIMENSION", "Key": "SERVICE"}
        ]
    )
    return response

def save_to_s3(data: dict, date_str: str) -> str:
    # Lưu dữ liệu chi phí vào S3, phân vùng theo năm/tháng/ngày
    dt= datetime.strptime(date_str, "%Y-%m-%d")
    key = f"cost-data/year={dt.year}/month={dt.month:02d}/day={dt.day:02d}/cost_{date_str}.json"

    s3_client.put_object(
        Bucket = BUCKET_NAME,
        Key = key,
        Body = json.dumps(data, default=str),
        ContentType = "application/json",
    )

    return key

def send_event_to_sqs(date_str: str, s3_key: str, total_cost: float) -> None:
    # Đẩy sự kiện vào SQS để Analyzer xử lý
    message = {
        "date": date_str,
        "s3_key": s3_key,
        "total_cost": total_cost,
        "collected_at": datetime.utcnow().isoformat(),
    }

    sqs_client.send_message(
        QueueUrl = QUEUE_URL,
        MessageBody = json.dumps(message)
    )

def lambda_handler(event, context):
    # Điểm vào của Lambda - được EventBridge gọi
    # Lấy dữ liệu của ngày hôm qua (Cost Explorer có độ trễ tới 24h)
    yesterday = datetime.utcnow().date() - timedelta(days = 1)
    start_date = yesterday.strftime("%Y-%m-%d")
    end_date = (yesterday + timedelta(days = 1)).strftime("%Y-%m-%d")

    print(f"[Collector] Get Cost data for date   {start_date}")

    # Gọi Cost Explorer
    cost_data = get_cost_data(start_date, end_date)

    # Tính tổng chi phí trong ngày
    total_cost = 0.0
    for result in cost_data.get("ResultsByTime", []):
        for group in result.get("Groups", []):
            amount = group["Metrics"]["UnblendedCost"]["Amount"]
            total_cost += float(amount)

    # Ghi vào S3
    s3_key = save_to_s3(cost_data, start_date)
    print(f"[Collector] Wrote data to S3://{BUCKET_NAME}/{s3_key}")

    # Đẩy event sang SQS
    send_event_to_sqs(start_date, s3_key, round(total_cost, 4))
    print(f"[Collector] Sent event to SQS. Total daily cost: ${total_cost:.2f}")

    return {
        "statusCode": 200,
        "date": start_date,
        "s3_key": s3_key,
        "total_cost": round(total_cost, 4),
    }
```

#### Cấu hình IAM Role và triển khai Collector

Tiếp theo, chúng ta sẽ tạo file `lambda_collector.tf`. File này là cầu nối giúp đưa đoạn code của bạn lên môi trường AWS và cấu hình cách nó hoạt động.

File này thực hiện ba nhiệm vụ chính:

1. **Đóng gói tự động**: Nó sẽ tự động nén thư mục chứa code Python (`handler.py`) thành một file `.zip` để chuẩn bị tải lên AWS.
2. **Cấu hình môi trường chạy**: Tạo `Lambda function` trên AWS, tải file zip lên, gắn quyền IAM (đã tạo ở phần trước) và thiết lập môi trường.
3. **Quản lý Log**: Nó tạo sẵn một nhóm Log trên **CloudWatch** (Log Group) với thời gian lưu trữ 14 ngày để bạn có thể xem lại lịch sử chạy của hàm mà không lo tốn quá nhiều chi phí lưu Log rác.

Việc cấu hình Terraform ở bước này giúp tự động hóa hoàn toàn quy trình triển khai. Thay vì mỗi lần sửa code, bạn phải tự nén file bằng tay rồi lên giao diện AWS upload, Terraform sẽ tự động so sánh mã băm, đóng gói và cập nhật hàm Lambda chỉ với một câu lệnh.

```hcl
# lambda_collector.tf - Hàm Lambda Collector + đóng gói code

# Đóng gói code Python thành file zip
data "archive_file" "collector_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/collector"       # đường dẫn thư mục chứa file code Python
  output_path = "${path.module}/build/collector.zip"    # đường dẫn lưu file zip
}

# Log group cho Lambda (đặt retention để tránh tốn chi phí log)
resource "aws_cloudwatch_log_group" "collector" {
  name              = "/aws/lambda/${var.project_name}-collector"
  retention_in_days = 14       # Tự động xóa Log sau 14 ngày.
}

# Hàm Lambda Collector
resource "aws_lambda_function" "collector" {
  function_name = "${var.project_name}-collector"
  role          = aws_iam_role.collector.arn     # Cấp quyền (IAM Role) đã tạo trước đó cho hàm này
  handler       = "handler.lambda_handler"       # Hàm sẽ chạy khi Lambda được gọi
  runtime       = "python3.12"                   # Môi trường chạy code
  timeout       = 60                             # Thời gian tối đa Lambda được phép chạy (s)
  memory_size   = 128                            # Lượng RAM cấp cho Lambda (MB)

  filename         = data.archive_file.collector_zip.output_path            # Trỏ tới file zip đã nén ở trên để upload
  source_code_hash = data.archive_file.collector_zip.output_base64sha256    # Kiểm tra mã băm để phát hiện nếu code có thay đổi mới cập nhật

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cost_data.id     # Đưa tên bucket vào biến môi trường để code Python có thể gọi
      QUEUE_URL   = aws_sqs_queue.events.url       # Đưa URL của SQS Queue vào biến môi trường để code Python đọc
    }
  }

  depends_on = [aws_cloudwatch_log_group.collector] # Đợi Log Group được tạo xong mới bắt đầu tạo Lambda
}
```

#### Nội dung tiếp theo





