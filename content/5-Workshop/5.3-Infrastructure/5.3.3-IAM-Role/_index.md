---
title : "Create an IAM Role for Lambda"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3.3 </b> "
---

In this section, we will create the `iam.tf` file to define the **access permissions** through an IAM Role and IAM Policy for a Lambda function called Lambda Collector.

On AWS, services such as Lambda do not have permission to interact with other AWS resources by default. To allow a Lambda function to perform its tasks, we must explicitly grant the required permissions. Instead of assigning broad Administrator permissions, we follow the principle of least privilege by granting only the permissions required for the function to complete its responsibilities.

Specifically, Lambda Collector needs permission to:

- Read cost data from **AWS Cost Explorer**
- Write the collected data to the **Amazon S3 bucket** created earlier
- Send messages to an **Amazon SQS queue**
- Write logs to **Amazon CloudWatch**

```hcl
# Define the trust policy that allows the AWS Lambda service to assume this role.
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Create a dedicated IAM role for the Lambda Collector function.
resource "aws_iam_role" "collector" {
  name               = "${var.project_name}-collector-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Define the required permissions following the principle of least privilege.
data "aws_iam_policy_document" "collector_policy" {
  # Allow access to the Cost Explorer API to retrieve cost data.
  statement {
    sid       = "CostExplorerRead"
    effect    = "Allow"
    actions   = ["ce:GetCostAndUsage"]
    resources = ["*"]
  }

  # Allow writing cost data to the designated S3 bucket.
  statement {
    sid       = "S3WriteCostData"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cost_data.arn}/*"]
  }

  # Allow sending messages to the SQS queue.
  statement {
    sid       = "SQSSendMessage"
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = ["${aws_sqs_queue.events.arn}"]
  }

  # Allow writing logs to Amazon CloudWatch.
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

# Attach the IAM policy to the IAM role.
resource "aws_iam_role_policy" "collector" {
  name   = "${var.project_name}-collector-policy"
  role   = aws_iam_role.collector.id
  policy = data.aws_iam_policy_document.collector_policy.json
}
```

#### Next Content

[Create an Amazon SNS Topic for Cost Alerts](../5.3.4-SNS-Topic/)