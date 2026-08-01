
"""
Cách dùng (chạy trong WSL, cần AWS CLI đã cấu hình):
    python generate_test_data.py <TEN_BUCKET>

Script sẽ:
  1. Sinh dữ liệu lịch sử + dữ liệu ngày test cho từng kịch bản.
  2. Upload lên S3 đúng cấu trúc phân vùng mà Analyzer đọc.
  3. In ra event SQS mẫu để bạn dán vào Lambda Test Console cho từng kịch bản.

Giả định cấu hình Analyzer: COST_THRESHOLD=10, SPIKE_MULTIPLIER=1.5, HISTORY_DAYS=7
"""

import sys
import json
import subprocess
from datetime import datetime, timedelta

def make_cost_json(services: dict, date_str) -> dict:
    groups = [
        {
            "Keys": [name],
            "Metrics": {"UnblendedCost": {"Amount": f"{amount:.2f}", "Unit": "USD"}}
        }
        for name, amount in services.items()
    ]
    return {
        "ResultsByTime": [
            {
                "TimePeriod": {"Start": date_str, "End": date_str},
                "Total": {},
                "Groups": groups,
                "Estimated": False,
            }
        ]
    }

def s3_key_for(date_str: str) -> str:
    dt = datetime.strptime(date_str, "%Y-%m-%d")
    return f"cost-data/year={dt.year}/month={dt.month:02d}/day={dt.day:02d}/cost_{date_str}.json"

def upload(bucket: str, date_str: str, services: dict):
    data = make_cost_json(services, date_str)
    fname = f"/tmp/cost_{date_str}.json"
    
    with open(fname, "w") as f:
        json.dump(data, f)
    key = s3_key_for(date_str)
    subprocess.run(["aws", "s3", "cp", fname, f"s3://{bucket}/{key}"], check = True)
    total = sum(services.values())
    print(f"{date_str}: total ${total:.2f} -> s3://{bucket}/{key}")
    
    return key, total

def sqs_event(date_str: str, key: str, total: float) -> str:
    body = json.dumps({"date": date_str, "s3_key": key, "total_cost": round(total, 4)})
    return json.dumps({"Records": [{"body": body}]}, indent = 2)


def main():
    if len(sys.argv) < 2:
        print("Cách dùng: python test_data.py <BUCKET_NAME>")
        sys.exit(1)
    bucket = sys.argv[1]

    # ngày "hôm nay"
    base = datetime(2026, 6, 1)

    scenarios = {
        "INFO": {
            "hist_daily": {"AWS Lambda": 3.0, "Amazon S3": 2.0}, # ~$5/history days
            "test_day": {"AWS Lambda": 4.0, "Amazon S3": 2.0}, # $6 <= 10, không đột biến
            "test_date": "2026-07-17",
        },
        "WARNING": {
            "hist_daily": {"Amazon EC2": 6.0, "Amazon S3": 3.0}, # ~9$/ history day
            "test_day": {"Amazon EC2": 8.0, "Amazon S3": 4.0}, # $12 > 10, nhưng 9*1.5 = 13.5
            "test_date": "2026-06-25",
        },
        "CRITICAL": {
            "hist_daily": {"AWS Lambda": 2.0, "Amazon S3": 1.0},  # ~$3/ history day
            "test_day": {"Amazon EC2": 45.0, "Amazon RDS": 7.0}, # $52 > 3*1.5 = 4.5
            "test_date": "2026-07-05",
        },
    }

    for name, sc in scenarios.items():
        print(f"\n===== SCENARIO {name} =====")
        test_dt = datetime.strptime(sc["test_date"], "%Y-%m-%d")
        
        # upload 7 ngày lịch sử trước ngày test
        for i in range(1, 8):
            hist_date = (test_dt - timedelta(days = i)).strftime("%Y-%m-%d")
            upload(bucket, hist_date, sc["hist_daily"])

        # upload day test
        key, total = upload(bucket, sc["test_date"], sc["test_day"])

        print(f"\n >>> Event SQS to test scenario {name} (past this into Lambda Test Console): ")
        print(sqs_event(sc["test_date"], key, total))


if __name__ == "__main__":
    main()
    