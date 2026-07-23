---
title : "Create an Amazon SNS Topic for Cost Alerts"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.3.4 </b> "
---

Next, we will create the `lambda/sns.tf` file. This file is used to provision the **Amazon Simple Notification Service** (SNS). Its primary purpose is to create a notification channel and connect it to your email address.

The main objective of **CloudCost Insight** is to detect abnormal cloud spending and notify administrators as quickly as possible. However, a Lambda function cannot send email notifications directly. Therefore, Amazon SNS acts as the messaging service that delivers alert notifications.

This configuration includes:

- Creating an SNS topic
- Creating an email subscription
- Configuring access control

```hcl
# Create an SNS topic that serves as the central channel for cost alerts.
resource "aws_sns_topic" "cost_alerts" {
  name = "${var.project_name}-cost-alerts"
}

# Create an email subscription so notifications are sent whenever a cost alert is published.
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.cost_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Allow only your AWS account and Amazon CloudWatch to publish messages to this topic.
resource "aws_sns_topic_policy" "cost_alerts" {
  arn = aws_sns_topic.cost_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowAccountPublish"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.cost_alerts.arn
      },

      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.cost_alerts.arn
      }
    ]
  })
}
```

#### Next Content

- [Create an Amazon SQS Queue and a Dead Letter Queue](../5.3.5-SQS-Queue-DLQ/)