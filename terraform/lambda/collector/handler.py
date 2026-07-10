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
