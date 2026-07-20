---
title : "Define Terraform Outputs"
date : 2024-01-01
weight : 7
chapter : false
pre : " <b> 5.3.7 </b> "
---

Next, we will create the `outputs.tf` file. This is the final step in building the core infrastructure. The purpose of this file is to define the output values that Terraform displays after the deployment is complete.

When Terraform finishes provisioning the infrastructure on AWS, it creates many resources with automatically generated values. For example:

- An S3 bucket name that includes the AWS Account ID
- The URL of the Amazon SQS queue
- The endpoint URLs for Amazon API Gateway and Amazon CloudFront

Instead of opening the AWS Management Console and manually navigating through each service to locate and copy these values, the `outputs.tf` file instructs Terraform to display all important information directly in the terminal after the deployment is complete. This makes it much easier to retrieve the information needed for the next configuration steps or to quickly access the Web Dashboard.

```hcl
# Cost data storage bucket
output "cost_data_bucket_name" {
  description = "Name of the S3 bucket storing cost data"
  value       = aws_s3_bucket.cost_data.id
}

output "cost_data_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.cost_data.arn
}

# Amazon SNS
output "sns_topic_arn" {
  description = "ARN of the SNS topic for sending alerts"
  value       = aws_sns_topic.cost_alerts.arn
}

# Amazon SQS
output "sqs_events_queue_url" {
  description = "URL of the main SQS queue"
  value       = aws_sqs_queue.events.url
}

output "sqs_dlq_url" {
  description = "URL of the Dead Letter Queue"
  value       = aws_sqs_queue.dlq.url
}

# Lambda functions and scheduling
output "collector_role_arn" {
  description = "ARN of the IAM role for the Lambda Collector"
  value       = aws_iam_role.collector.arn
}

output "schedule_rule_name" {
  description = "Name of the EventBridge scheduling rule"
  value       = aws_cloudwatch_event_rule.schedule.name
}

output "collector_function_name" {
  description = "Name of the Lambda Collector function"
  value       = aws_lambda_function.collector.function_name
}

output "analyzer_role_arn" {
  description = "ARN of the IAM role for the Lambda Analyzer"
  value       = aws_iam_role.analyzer.arn
}

# CloudWatch monitoring
output "alarm_collector_errors" {
  description = "Alarm name for monitoring Collector errors"
  value       = aws_cloudwatch_metric_alarm.collector_errors.alarm_name
}

output "alarm_analyzer_errors" {
  description = "Alarm name for monitoring Analyzer errors"
  value       = aws_cloudwatch_metric_alarm.analyzer_errors.alarm_name
}

output "alarm_dlq_messages" {
  description = "Alarm name for monitoring DLQ messages"
  value       = aws_cloudwatch_metric_alarm.dlq_message.alarm_name
}

# API Gateway
output "api_endpoint" {
  description = "API endpoint URL for web frontend requests"
  value       = "${aws_apigatewayv2_stage.default.invoke_url}/costs"
}

output "api_function_name" {
  description = "Name of the Lambda API function"
  value       = aws_lambda_function.api.function_name
}

# Web Dashboard
output "web_dashboard_url" {
  description = "HTTPS URL for accessing the Web Dashboard through CloudFront"
  value       = "https://${aws_cloudfront_distribution.web.domain_name}"
}

output "web_bucket_name" {
  description = "Name of the S3 bucket hosting the static website"
  value       = aws_s3_bucket.web.id
}
```

#### Next Content

- [Deploy the Infrastructure](../5.3.8-Deploy-infrastructure/)