from unittest.mock import MagicMock

from conftest import load_lambda_module


def test_get_cost_data_calls_cost_explorer():
    collector = load_lambda_module(
        "collector_handler",
        "terraform/lambda/collector/handler.py",
    )
    collector.ce_client = MagicMock()
    collector.ce_client.get_cost_and_usage.return_value = {"ResultsByTime": []}

    result = collector.get_cost_data("2026-07-01", "2026-07-02")

    assert result == {
        "ResultsByTime": [],
        "GroupDefinitions": [{"Type": "DIMENSION", "Key": "SERVICE"}],
    }
    collector.ce_client.get_cost_and_usage.assert_called_once_with(
        TimePeriod={"Start": "2026-07-01", "End": "2026-07-02"},
        Granularity="DAILY",
        Metrics=["UnblendedCost"],
        GroupBy=[{"Type": "DIMENSION", "Key": "SERVICE"}],
    )


def test_save_to_s3_uses_partitioned_key():
    collector = load_lambda_module(
        "collector_handler",
        "terraform/lambda/collector/handler.py",
    )
    collector.s3_client = MagicMock()

    key = collector.save_to_s3({"ResultsByTime": []}, "2026-07-15")

    assert key == "cost-data/year=2026/month=07/day=15/cost_2026-07-15.json"
    collector.s3_client.put_object.assert_called_once()

    call = collector.s3_client.put_object.call_args.kwargs
    assert call["Bucket"] == "test-cost-data-bucket"
    assert call["Key"] == key
    assert call["ContentType"] == "application/json"


def test_send_event_to_sqs_contains_expected_values():
    collector = load_lambda_module(
        "collector_handler",
        "terraform/lambda/collector/handler.py",
    )
    collector.sqs_client = MagicMock()

    collector.send_event_to_sqs(
        "2026-07-15",
        "cost-data/example.json",
        12.34,
    )

    collector.sqs_client.send_message.assert_called_once()
    call = collector.sqs_client.send_message.call_args.kwargs

    assert call["QueueUrl"].endswith("/events")
    assert '"date": "2026-07-15"' in call["MessageBody"]
    assert '"total_cost": 12.34' in call["MessageBody"]
