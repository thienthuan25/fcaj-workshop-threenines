import importlib.util
from pathlib import Path

# pyrefly: ignore [missing-import]
import pytest

ROOT_DIR = Path(__file__).resolve().parents[1]


@pytest.fixture(autouse=True)
def aws_environment(monkeypatch):
    """Cấu hình giả để boto3 không tìm AWS credentials thật."""
    monkeypatch.setenv("AWS_DEFAULT_REGION", "us-east-1")
    monkeypatch.setenv("AWS_ACCESS_KEY_ID", "testing")
    monkeypatch.setenv("AWS_SECRET_ACCESS_KEY", "testing")
    monkeypatch.setenv("BUCKET_NAME", "test-cost-data-bucket")
    monkeypatch.setenv(
        "QUEUE_URL", "https://sqs.us-east-1.amazonaws.com/123456789012/events"
    )
    monkeypatch.setenv(
        "SNS_TOPIC_ARN",
        "arn:aws:sns:us-east-1:123456789012:cost-alerts",
    )
    monkeypatch.setenv("COST_THRESHOLD_USD", "10")
    monkeypatch.setenv("SPIKE_MULTIPLIER", "1.5")
    monkeypatch.setenv("HISTORY_DAYS", "7")
    monkeypatch.setenv("MAX_DAYS", "30")


def load_lambda_module(module_name: str, relative_path: str):
    """Import từng handler.py với tên riêng để tránh trùng module."""
    path = ROOT_DIR / relative_path
    spec = importlib.util.spec_from_file_location(module_name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module
