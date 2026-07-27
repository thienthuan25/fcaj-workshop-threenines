---
title : "Deploy Lambda Collector"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.4.1 </b> "
---

#### Write the Lambda Collector Code

We will create the file `terraform/lambda/collector/handler.py`. This file serves as the primary data collection component of the entire **CloudCost Insight** system.

Whenever it is automatically triggered by EventBridge each day, this function performs a three-step workflow:

1. **Collect data**: Calls the AWS Cost Explorer API to retrieve a detailed report of all costs incurred on the previous day, grouped by AWS service.
2. **Store data**: Saves the retrieved data securely into an S3 bucket, automatically organizing it into a clean folder structure based on year/month/day.
3. **Trigger processing**: After storing the data, the function calculates the total daily cost, packages it together with the S3 object path into an event, and sends it to an SQS queue to instruct the Lambda Analyzer to begin processing.

Separating the data collection and data analysis processes ensures that even if the analysis fails, the original cost data remains safely preserved and intact in Amazon S3.

```python
"""
Lambda Collector - CloudCost Insight

Functions:
 1. Call the AWS Cost Explorer API to retrieve cost data (for the previous day)
 2. Store the raw data in Amazon S3 (partitioned by year/month/day)
 3. Send an event to Amazon SQS for Lambda Analyzer to process

Triggered periodically by EventBridge (default: once per day)
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
    # Call the Cost Explorer API to retrieve cost data grouped by service
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
    # Store cost data in S3, partitioned by year/month/day
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
    # Send an event to SQS for Analyzer processing
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
    # Lambda entry point - invoked by EventBridge
    # Retrieve yesterday's data (Cost Explorer has up to a 24-hour delay)
    yesterday = datetime.utcnow().date() - timedelta(days = 1)
    start_date = yesterday.strftime("%Y-%m-%d")
    end_date = (yesterday + timedelta(days = 1)).strftime("%Y-%m-%d")

    print(f"[Collector] Get cost data for date {start_date}")

    # Call Cost Explorer
    cost_data = get_cost_data(start_date, end_date)

    # Calculate the total daily cost
    total_cost = 0.0
    for result in cost_data.get("ResultsByTime", []):
        for group in result.get("Groups", []):
            amount = group["Metrics"]["UnblendedCost"]["Amount"]
            total_cost += float(amount)

    # Save data to S3
    s3_key = save_to_s3(cost_data, start_date)
    print(f"[Collector] Wrote data to S3://{BUCKET_NAME}/{s3_key}")

    # Send an event to SQS
    send_event_to_sqs(start_date, s3_key, round(total_cost, 4))
    print(f"[Collector] Sent event to SQS. Total daily cost: ${total_cost:.2f}")

    return {
        "statusCode": 200,
        "date": start_date,
        "s3_key": s3_key,
        "total_cost": round(total_cost, 4),
    }
```

#### Configure the IAM Role and Deploy the Collector

1. Next, create the file `terraform/lambda_collector.tf`. This file acts as the bridge that deploys your code to AWS and defines how it runs. It performs three main tasks:

- **Automatic packaging**: Compresses the Python source directory (`handler.py`) into a `.zip` file that is ready to be uploaded to AWS.
- **Runtime configuration**: Creates the AWS `Lambda function`, uploads the ZIP package, attaches the IAM role created earlier, and configures the runtime environment.
- **Log management**: Creates a dedicated **CloudWatch Log Group** with a 14-day retention period so you can review execution logs without accumulating unnecessary logging costs.

Using Terraform for this step fully automates the deployment process. Instead of manually compressing your code and uploading it through the AWS Console after every change, Terraform automatically detects source code changes using a hash, packages the code, and updates the Lambda function with a single command.

```hcl
# lambda_collector.tf - Lambda Collector function + code packaging

# Package the Python source code into a ZIP file
data "archive_file" "collector_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/collector"       # Path to the Python source code directory
  output_path = "${path.module}/build/collector.zip"    # Output ZIP file path
}

# CloudWatch Log Group for Lambda (set retention to reduce logging costs)
resource "aws_cloudwatch_log_group" "collector" {
  name              = "/aws/lambda/${var.project_name}-collector"
  retention_in_days = 14       # Automatically delete logs after 14 days
}

# Lambda Collector function
resource "aws_lambda_function" "collector" {
  function_name = "${var.project_name}-collector"
  role          = aws_iam_role.collector.arn     # Attach the previously created IAM Role
  handler       = "handler.lambda_handler"       # Entry point of the Lambda function
  runtime       = "python3.12"                   # Runtime environment
  timeout       = 60                             # Maximum execution time (seconds)
  memory_size   = 128                            # Allocated memory (MB)

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

2. Open the `terraform/eventbridge.tf` file and add the following configuration to the end of the file:

```hcl
# Automatically invoke the Lambda Collector on schedule
resource "aws_cloudwatch_event_target" "collector" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "collector-lambda"
  arn       = aws_lambda_function.collector.arn
}

# Allow EventBridge to invoke the Lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.collector.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}
```

3. Next, open `terraform/iam.tf` and add the following configuration to the `data "aws_iam_policy_document" "collector_policy"` block:

```hcl
# Allow sending events to the primary SQS queue
statement {
    sid = "SQSSendMessage"
    effect = "Allow"
    actions = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.events.arn]
}
```

4.  Finally, open `terraform/outputs.tf` and add the following configuration to the end of the file:

```hcl
# Print the name of the Lambda Collector function to the screen after deployment
output "collector_function_name" {
  description = "Name of Lambda Collector"
  value       = aws_lambda_function.collector.function_name
}
```

#### Next

- [Deploy Lambda Analyzer](../5.4.2-Lambda-Analyzer/)