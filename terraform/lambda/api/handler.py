# cung cấp dữ liệu chi phí cho Web Dashboard:
# - đọc các file dữ liệu chi phí từ S3 (do Collector ghi)
# - tổng hợp thành JSON: chi phí theo ngày, theo dịch vụ, tổng, trạng thái
# - Trả về cho Frontend (qua api gateway) để vẽ biểu đồ

# được gọi bởi API gateway (HTTP GET). Trả Json kèm CORS header để web gọi được

import os
import json
import boto3
from datetime import datetime, timedelta
from collections import defaultdict

BUCKET_NAME = os.environ["BUCKET_NAME"]
COST_THRESHOLD = float(os.environ.get("COST_THRESHOLD_USD", "10"))
SPIKE_MULTIPLIER = float(os.environ.get("SPIKE_MULTIPLIER", "1.5"))
# Số ngày dữ liệu tối đa trả về cho dashboard
MAX_DAYS = int(os.environ.get("MAX_DAYS", "30"))

s3_client = boto3.client("s3")


def _cors_response(status_code: int, body: dict) -> dict:
    """Trả response kèm CORS header để web frontend gọi được."""
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, OPTIONS",
            "Access-Control-Allow-Headers": "Content-Type",
        },
        "body": json.dumps(body, default=str),
    }


def list_cost_files() -> list:
    """Liệt kê các file dữ liệu chi phí trong S3 (dưới prefix cost-data/)."""
    keys = []
    paginator = s3_client.get_paginator("list_objects_v2")
    for page in paginator.paginate(Bucket=BUCKET_NAME, Prefix="cost-data/"):
        for obj in page.get("Contents", []):
            if obj["Key"].endswith(".json"):
                keys.append(obj["Key"])
    return sorted(keys)


def read_cost_file(key: str) -> dict:
    """Đọc 1 file dữ liệu chi phí JSON từ S3."""
    response = s3_client.get_object(Bucket=BUCKET_NAME, Key=key)
    return json.loads(response["Body"].read())


def parse_daily(cost_data: dict) -> tuple:
    """Từ dữ liệu Cost Explorer, trả về (ngày, tổng chi phí, dict chi phí theo dịch vụ)."""
    day = None
    total = 0.0
    services = defaultdict(float)
    for result in cost_data.get("ResultsByTime", []):
        day = result.get("TimePeriod", {}).get("Start")
        for group in result.get("Groups", []):
            svc = group["Keys"][0]
            amount = float(group["Metrics"]["UnblendedCost"]["Amount"])
            services[svc] += amount
            total += amount
    return day, round(total, 2), dict(services)


def lambda_handler(event, context):
    """Được API Gateway gọi (HTTP GET). Trả dữ liệu tổng hợp cho dashboard."""
    try:
        keys = list_cost_files()[-MAX_DAYS:]  # lấy tối đa MAX_DAYS ngày gần nhất

        daily_costs = []          # [{date, total, status}]
        service_totals = defaultdict(float)  # tổng chi phí theo dịch vụ (toàn kỳ)
        grand_total = 0.0

        # Đọc từng file, tổng hợp
        for key in keys:
            data = read_cost_file(key)
            day, total, services = parse_daily(data)
            if day is None:
                continue
            daily_costs.append({"date": day, "total": total})
            grand_total += total
            for svc, amt in services.items():
                service_totals[svc] += amt

        # Tính trạng thái từng ngày (dựa ngưỡng + trung bình động)
        for i, d in enumerate(daily_costs):
            prev = [x["total"] for x in daily_costs[max(0, i - 7):i]]
            avg = sum(prev) / len(prev) if prev else 0
            if avg > 0 and d["total"] > avg * SPIKE_MULTIPLIER:
                d["status"] = "CRITICAL"
            elif d["total"] > COST_THRESHOLD:
                d["status"] = "WARNING"
            else:
                d["status"] = "NORMAL"

        # Top dịch vụ tốn chi phí nhất
        top_services = sorted(service_totals.items(), key=lambda x: x[1], reverse=True)[:5]

        result = {
            "grand_total": round(grand_total, 2),
            "threshold": COST_THRESHOLD,
            "days_count": len(daily_costs),
            "daily_costs": daily_costs,
            "top_services": [{"service": s, "cost": round(c, 2)} for s, c in top_services],
        }
        return _cors_response(200, result)

    except Exception as e:
        print(f"[API] Lỗi: {e}")
        return _cors_response(500, {"error": str(e)})