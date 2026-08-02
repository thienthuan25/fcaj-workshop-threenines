from conftest import load_lambda_module


def sample_cost_data():
    return {
        "ResultsByTime": [
            {
                "Groups": [
                    {
                        "Keys": ["Amazon EC2"],
                        "Metrics": {"UnblendedCost": {"Amount": "8.50"}},
                    },
                    {
                        "Keys": ["Amazon S3"],
                        "Metrics": {"UnblendedCost": {"Amount": "2.00"}},
                    },
                    {
                        "Keys": ["AWS Lambda"],
                        "Metrics": {"UnblendedCost": {"Amount": "1.25"}},
                    },
                ]
            }
        ]
    }


def test_compute_total_and_top_services():
    analyzer = load_lambda_module(
        "analyzer_handler",
        "terraform/lambda/analyzer/handler.py",
    )

    result = analyzer.compute_total_and_top(sample_cost_data())

    assert result["total_cost"] == 11.75
    assert result["top_services"] == [
        ("Amazon EC2", 8.5),
        ("Amazon S3", 2.0),
        ("AWS Lambda", 1.25),
    ]


def test_classify_severity_returns_info_for_normal_cost():
    analyzer = load_lambda_module(
        "analyzer_handler",
        "terraform/lambda/analyzer/handler.py",
    )

    severity, reasons = analyzer.classify_severity(total=6, avg=5)

    assert severity == "INFO"
    assert reasons == []


def test_classify_severity_returns_warning_when_threshold_exceeded():
    analyzer = load_lambda_module(
        "analyzer_handler",
        "terraform/lambda/analyzer/handler.py",
    )

    severity, reasons = analyzer.classify_severity(total=12, avg=9)

    assert severity == "WARNING"
    assert "Budget threshold exceeded ($10.00)" in reasons


def test_classify_severity_returns_critical_for_cost_spike():
    analyzer = load_lambda_module(
        "analyzer_handler",
        "terraform/lambda/analyzer/handler.py",
    )

    severity, reasons = analyzer.classify_severity(total=20, avg=5)

    assert severity == "CRITICAL"
    assert any("Cost spike detected" in reason for reason in reasons)
