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

# Đọc cấu hình từ biến môi trường (Terraform truyền vào)
BUCKET_NAME = os.environ["BUCKET_NAME"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]
COST_THRESHOLD = float(os.environ.get("COST_THRESHOLD_USD", "10"))

s3_client = boto3.client("s3")
sns_client = boto3.client("sns")

def read_cost_from_s3(s3_key: str) -> dict:
    # Đọc file dữ liệu chi phí (.json) từ S3
    response = s3_client.get_object(Bucket = BUCKET_NAME, Key = s3_key)
    return json.loads(response["Body"].read())

def analyze_cost(cost_data: dict) -> dict:
    # Phân tích dữ liệu chi phí:
    # - tính tổng chi phí trong ngày
    # - lấy top dịch vụ tốn nhiều nhất (đưa vào cảnh báo)
    total_cost = 0.0
    service_costs = {}

    for result in cost_data.get("ResultsByTime", []):
        for group in result.get("Groups", []):
            service = group["Keys"][0]
            amount = float(group["Metrics"]["UnblendedCost"]["Amount"])
            service_costs[service] = service_costs.get(service, 0.0) + amount
            total_cost += amount

    # Sắp xếp dịch vụ theo chi phí giảm dần, lấy tóp 5
    top_services = sorted(service_costs.items(), key = lambda x: x[1], reverse = True)[:5]

    return {
        "total_cost": round(total_cost, 4),
        "top_services": top_services,
    }

def send_alert(date_str: str, analysis: dict) -> None:
    # Gửi cảnh báo qua SNS khi chi phí vượt ngưỡng
    total = analysis["total_cost"]

    lines = [
        "AWS COST ALERT - CloudCost Insight",
        "",
        f"Day: {date_str}",
        f"Total cost: ${total:.4f}",
        f"Alert threshold: ${COST_THRESHOLD:.2f}"
        "",
        f"Top Service by cost:",
    ]
    for service, cost in analysis["top_services"]:
        lines.append(f" - {service}: ${cost:.4f}")

    message = "\n".join(lines)

    sns_client.publish(
        TopicArn = SNS_TOPIC_ARN,
        Subject = f"[CloudCost Insight] Cost alert for date {date_str}",
        Message = message,
    )

def lambda_handler(event, context):
    """Điểm vào — được SQS kích hoạt. Mỗi record là 1 sự kiện từ Collector."""
    print("INCOMING EVENT:", event)
    processed = 0

    for record in event.get("Records", []):
        body = json.loads(record["body"])
        date_str = body["date"]
        s3_key = body["s3_key"]

        print(f"[Analyzer] Processing cost date for date {date_str} (key = {s3_key})")

        # Đọc dữ liệu chi phí từ S3
        cost_data = read_cost_from_s3(s3_key)

        # Processing
        analysis = analyze_cost(cost_data)
        total = analysis["total_cost"]
        print(f"[Analyzer] Total cost for date {date_str}: ${total:.4f} (threshold ${COST_THRESHOLD:.2f})")

        # so sánh ngưỡng ngân sách, nếu vượt thì cảnh báo
        if total > COST_THRESHOLD:
            print(f"[Analyzer] THRESHOLD EXCEEDED! Sending alert via SNS.")
            send_alert(date_str, analysis)
        else:
            print(f"[Analyzer] Cost within threshold, no alert needed.")

        processed += 1

    return {"statusCode": 200, "processed": processed}

