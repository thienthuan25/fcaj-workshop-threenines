---
title : "Deploying Lambda Analyzer"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.4.2 </b> "
---

#### Adding Configuration Variables for the Analyzer

The Analyzer requires two configuration variables to support the cost spike detection logic. Add the following variables to `variables.tf`:

```hcl
# Multiplier used to identify abnormal cost spikes by comparing the current cost with the historical average multiplied by this value
variable "spike_multiplier" {
  description = "Spike multiplier: if cost > historical average * this multiplier, it is considered an abnormal spike"
  type        = number
  default     = 1.5 # An alert is triggered if the current cost exceeds 1.5 times the historical average
}

# Number of previous days used to calculate the historical average
variable "history_days" {
  description = "Number of historical days used to calculate the average cost (for spike detection)"
  type        = number
  default     = 7 # Calculate the average cost over the last 7 days
}
```

#### Writing the Lambda Analyzer Code

Next, create the file `lambda/analyzer/handler.py`, which contains the Python source code for the Lambda Analyzer function.

This function is triggered automatically whenever it receives a message from the Amazon SQS queue that was sent by the Collector. The processing workflow consists of three steps:

1. **Retrieve data**: Read the file path from the Amazon SQS message, then retrieve the corresponding cost data file from Amazon S3.
2. **Perform intelligent analysis**: Calculate the total daily cost, identify the top five AWS services with the highest costs, then read previous cost files from Amazon S3 to calculate the average cost over the last seven days.
3. **Make an alert decision**: Compare the current cost against two conditions:

- Does the cost exceed the predefined budget threshold?
- Has the cost increased abnormally compared with the historical average?

If either condition is satisfied, the function sends a detailed email alert to the user.

```python
""" 
Functions:
    1. Triggered by an Amazon SQS event sent from the Collector
    2. Read the corresponding cost data from Amazon S3
    3. Compare the total cost with the budget threshold and detect abnormal cost spikes
       compared with the historical average when available
    4. Send an alert through Amazon SNS if the threshold is exceeded or an abnormal spike is detected

Failed events are automatically moved to the Dead Letter Queue according to the SQS redrive policy
"""

import boto3
import os
import json
import boto3
from datetime import datetime, timedelta

# Read configuration from environment variables provided by Terraform
BUCKET_NAME = os.environ["BUCKET_NAME"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]
COST_THRESHOLD = float(os.environ.get("COST_THRESHOLD_USD", "10"))

# Cost spike multiplier
SPIKE_MULTIPLIER = float(os.environ.get("SPIKE_MULTIPLIER", "1.5"))
# Number of historical days used for averaging
HISTORY_DAYS = int(os.environ.get("HISTORY_DAYS", "7"))

s3_client = boto3.client("s3")
sns_client = boto3.client("sns")

def read_cost_from_s3(s3_key: str) -> dict:
    # Read the JSON cost data file from Amazon S3
    response = s3_client.get_object(Bucket = BUCKET_NAME, Key = s3_key)
    return json.loads(response["Body"].read())

def compute_total_and_top(cost_data: dict) -> dict:
    """Calculate the total cost and the top cost consuming services from Cost Explorer data."""
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
    # Calculate the average cost over the previous HISTORY_DAYS
    # Read historical files from Amazon S3 and return 0 if no history is available
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
    # Determine the alert severity based on the budget threshold and cost spike detection
    # Return (severity, reasons[])

    reasons = []
    severity = "INFO"

    # Budget threshold exceeded
    if total > COST_THRESHOLD:
        reasons.append(f"Budget threshold exceeded (${COST_THRESHOLD:.2f})")
        severity = "WARNING"

    # Abnormal increase compared with the historical average
    if avg > 0 and total > avg * SPIKE_MULTIPLIER:
        pct = ((total - avg) / avg) * 100
        reasons.append(f"Cost spike detected: {pct:.0f}% above the {HISTORY_DAYS} day historical average (${avg:.2f})")
        severity = "CRITICAL"

    return severity, reasons


def send_alert(date_str: str, analysis: dict, severity: str, reasons: list, avg: float) -> None:
    # Send an alert through Amazon SNS
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
        "Top services by cost:"
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
    """Lambda entry point. Triggered by Amazon SQS. Each record represents one event from the Collector."""
    processed = 0

    for record in event.get("Records", []):
        body = json.loads(record["body"])
        date_str = body["date"]
        s3_key = body["s3_key"]

        print(f"[Analyzer] Processing cost data for date {date_str} (key={s3_key})")

        # Read the current cost data
        cost_data = read_cost_from_s3(s3_key)
        analysis = compute_total_and_top(cost_data)
        total = analysis["total_cost"]

        # Calculate the historical average for spike detection
        avg = get_historical_average(date_str)
        print(f"[Analyzer] Total: ${total:.2f} | Average over {HISTORY_DAYS} days: ${avg:.2f} | Threshold: ${COST_THRESHOLD:.2f}")

        # Determine severity and send an alert if needed
        severity, reasons = classify_severity(total, avg)
        if reasons:
            print(f"[Analyzer] {severity}! Reason: {reasons}. Sending alert through Amazon SNS.")
            send_alert(date_str, analysis, severity, reasons, avg)
        else:
            print(f"[Analyzer] Cost is within the normal range. No alert is required.")

        processed += 1

    return {"statusCode": 200, "processed": processed}
```

#### Configuring the IAM Role and Deploying the Analyzer

Next, create the `lambda/lambda_analyzer.tf` file. This file provisions all AWS resources required to run the Lambda Analyzer function and performs the following tasks automatically:

1. **Grant security permissions**: Create the IAM permissions required for the Analyzer function to read cost data from Amazon S3, receive messages from Amazon SQS, and publish alerts through Amazon SNS.
2. **Package and deploy the code**: Compress the Python source code into a ZIP archive and upload it to AWS as a deployable Lambda function.
3. **Create the event integration**: Configure a direct connection between the Amazon SQS queue and the Analyzer function. Whenever a new cost event arrives in the queue, the Analyzer is invoked automatically.

The Python source code alone is not enough for AWS to execute the function because it also requires execution permissions and event sources. This Terraform configuration connects Amazon S3, Amazon SQS, Amazon SNS, and AWS Lambda into a fully automated processing pipeline.

```hcl
# IAM role for the Analyzer
resource "aws_iam_role" "analyzer" {
  name               = "${var.project_name}-analyzer-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Allow reading stored cost data from Amazon S3
data "aws_iam_policy_document" "analyzer_policy" {
  statement {
    sid       = "S3ReadCostData"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cost_data.arn}/*"]
  }

  # Allow listing objects in the S3 bucket
  statement {
    sid       = "S3ListBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.cost_data.arn]
  }

  # Receive and delete messages from the main SQS queue
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

  # Publish alerts through Amazon SNS
  statement {
    sid       = "SNSPublish"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.cost_alerts.arn]
  }

  # Write logs to Amazon CloudWatch
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

# Attach the IAM policy to the Analyzer role
resource "aws_iam_role_policy" "analyzer" {
  name   = "${var.project_name}-analyzer-policy"
  role   = aws_iam_role.analyzer.id
  policy = data.aws_iam_policy_document.analyzer_policy.json
}

# Package the source code
data "archive_file" "analyzer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/analyzer"
  output_path = "${path.module}/build/analyzer.zip"
}

# Create the CloudWatch Log Group
resource "aws_cloudwatch_log_group" "analyzer" {
  name              = "/aws/lambda/${var.project_name}-analyzer"
  retention_in_days = 14
}

# Lambda Analyzer function
resource "aws_lambda_function" "analyzer" {
  function_name = "${var.project_name}-analyzer"
  role          = aws_iam_role.analyzer.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
  timeout       = 60
  memory_size   = 128

  filename         = data.archive_file.analyzer_zip.output_path
  source_code_hash = data.archive_file.analyzer_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME        = aws_s3_bucket.cost_data.id
      SNS_TOPIC_ARN      = aws_sns_topic.cost_alerts.arn
      COST_THRESHOLD_USD = var.cost_threshold_usd
      SPIKE_MULTIPLIER   = var.spike_multiplier
      HISTORY_DAYS       = var.history_days
    }
  }

  depends_on = [aws_cloudwatch_log_group.analyzer]
}

# Automatically invoke Lambda Analyzer when a new message arrives in the Amazon SQS queue
resource "aws_lambda_event_source_mapping" "sqs_to_analyzer" {
  event_source_arn = aws_sqs_queue.events.arn
  function_name    = aws_lambda_function.analyzer.arn
  batch_size       = 10
  enabled          = true
}
```

#### Next Content

- [Monitoring](5.5-Monitoring/)