---
title : "Deploying Lambda Collector"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.4.1 </b> "
---

#### Writing the Lambda Collector Code

We will create the `lambda/collector/handler.py` file. This file serves as the main data collection component of the **CloudCost Insight** system.

Each time it is triggered automatically by EventBridge on a daily schedule, the function performs the following three steps:

1. **Retrieve data**: Call the AWS Cost Explorer API to generate a detailed report of all costs incurred during the previous day, grouped by AWS service.
2. **Store data**: Save the collected data securely in an Amazon S3 bucket and automatically organize it into a directory structure based on year, month, and day.
3. **Trigger processing**: After storing the data, calculate the total daily cost, package it together with the S3 object path into an event, and send it to an Amazon SQS queue so that Lambda Analyzer can begin processing.

Separating data collection from data analysis ensures that the original cost data remains safely stored in Amazon S3 even if the analysis process encounters an error.

```python
"""
Lambda Collector - CloudCost Insight
Functions:
 1. Call the AWS Cost Explorer API to retrieve cost data for the previous day
 2. Store the raw data in Amazon S3 using a year/month/day partition structure
 3. Send an event to Amazon SQS for Lambda Analyzer to process

Triggered automatically by Amazon EventBridge on a scheduled basis
Default schedule is once per day
"""

import boto3
import os
import json
import boto3
from datetime import datetime, timedelta

# Read configuration from environment variables
BUCKET_NAME = os.environ["BUCKET_NAME"]
QUEUE_URL = os.environ["QUEUE_URL"]

# Initialize AWS clients
ce_client = boto3.client("ce")
s3_client = boto3.client("s3")
sqs_client = boto3.client("sqs")

def get_cost_data(start_date: str, end_date: str) -> dict:
    # Retrieve cost data grouped by service from the Cost Explorer API
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
    # Store cost data in Amazon S3 using a year/month/day partition structure
    dt = datetime.strptime(date_str, "%Y-%m-%d")
    key = f"cost-data/year={dt.year}/month={dt.month:02d}/day={dt.day:02d}/cost_{date_str}.json"

    s3_client.put_object(
        Bucket = BUCKET_NAME,
        Key = key,
        Body = json.dumps(data, default=str),
        ContentType = "application/json",
    )

    return key

def send_event_to_sqs(date_str: str, s3_key: str, total_cost: float) -> None:
    # Send an event to Amazon SQS for Lambda Analyzer
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
    # Lambda entry point invoked by Amazon EventBridge
    # Retrieve yesterday's data because Cost Explorer may have up to a 24 hour delay
    yesterday = datetime.utcnow().date() - timedelta(days=1)
    start_date = yesterday.strftime("%Y-%m-%d")
    end_date = (yesterday + timedelta(days=1)).strftime("%Y-%m-%d")

    print(f"[Collector] Get cost data for date {start_date}")

    # Call Cost Explorer
    cost_data = get_cost_data(start_date, end_date)

    # Calculate the total daily cost
    total_cost = 0.0
    for result in cost_data.get("ResultsByTime", []):
        for group in result.get("Groups", []):
            amount = group["Metrics"]["UnblendedCost"]["Amount"]
            total_cost += float(amount)

    # Save the data to Amazon S3
    s3_key = save_to_s3(cost_data, start_date)
    print(f"[Collector] Wrote data to S3://{BUCKET_NAME}/{s3_key}")

    # Send the event to Amazon SQS
    send_event_to_sqs(start_date, s3_key, round(total_cost, 4))
    print(f"[Collector] Sent event to SQS. Total daily cost: ${total_cost:.2f}")

    return {
        "statusCode": 200,
        "date": start_date,
        "s3_key": s3_key,
        "total_cost": round(total_cost, 4),
    }
```

#### Configuring the IAM Role and Deploying the Collector

Next, we will create the `lambda_collector.tf` file. This file acts as the bridge that deploys your code to AWS and defines how the Lambda function runs.

This file performs three main tasks:

1. **Automatic packaging**: Compress the Python source directory containing `handler.py` into a `.zip` file that is ready for deployment to AWS.
2. **Runtime configuration**: Create the Lambda function on AWS, upload the ZIP package, attach the IAM role created earlier, and configure the runtime environment.
3. **Log management**: Create a dedicated CloudWatch Log Group with a retention period of 14 days so that you can review the execution history while keeping log storage costs under control.

Using Terraform for this step fully automates the deployment process. Instead of manually compressing the source code and uploading it through the AWS Console after every change, Terraform automatically detects changes by comparing the source code hash, rebuilds the deployment package, and updates the Lambda function with a single command.

```hcl
# lambda_collector.tf - Lambda Collector function and code packaging

# Package the Python source code into a ZIP archive
data "archive_file" "collector_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/collector"       # Directory containing the Python source code
  output_path = "${path.module}/build/collector.zip"    # Output path for the ZIP archive
}

# CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "collector" {
  name              = "/aws/lambda/${var.project_name}-collector"
  retention_in_days = 14       # Automatically delete logs after 14 days
}

# Lambda Collector function
resource "aws_lambda_function" "collector" {
  function_name = "${var.project_name}-collector"
  role          = aws_iam_role.collector.arn     # Attach the IAM role created earlier
  handler       = "handler.lambda_handler"       # Entry point of the Lambda function
  runtime       = "python3.12"                   # Runtime environment
  timeout       = 60                             # Maximum execution time in seconds
  memory_size   = 128                            # Memory allocation in MB

  filename         = data.archive_file.collector_zip.output_path
  source_code_hash = data.archive_file.collector_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cost_data.id
      QUEUE_URL   = aws_sqs_queue.events.url
    }
  }

  depends_on = [aws_cloudwatch_log_group.collector]
}
```

#### Next
```