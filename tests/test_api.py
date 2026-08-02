from conftest import load_lambda_module


def test_parse_daily_returns_total_and_services():
    api = load_lambda_module(
        "api_handler",
        "terraform/lambda/api/handler.py",
    )

    cost_data = {
        "ResultsByTime": [
            {
                "TimePeriod": {"Start": "2026-07-15"},
                "Groups": [
                    {
                        "Keys": ["Amazon EC2"],
                        "Metrics": {"UnblendedCost": {"Amount": "5.25"}},
                    },
                    {
                        "Keys": ["Amazon S3"],
                        "Metrics": {"UnblendedCost": {"Amount": "1.50"}},
                    },
                ],
            }
        ]
    }

    day, total, services = api.parse_daily(cost_data)

    assert day == "2026-07-15"
    assert total == 6.75
    assert services == {
        "Amazon EC2": 5.25,
        "Amazon S3": 1.5,
    }


def test_cors_response_returns_json_response():
    api = load_lambda_module(
        "api_handler",
        "terraform/lambda/api/handler.py",
    )

    response = api._response(200, {"status": "ok"})

    assert response["statusCode"] == 200
    assert response["headers"]["Content-Type"] == "application/json"
    assert response["body"] == '{"status": "ok"}'
