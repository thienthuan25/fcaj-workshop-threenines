# outputs.tf - Output values after apply

output "cost_data_bucket_name" {
  description = "Name of the S3 bucket storing cost data"
  value       = aws_s3_bucket.cost_data.id
}

output "cost_data_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.cost_data.arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for sending alerts"
  value       = aws_sns_topic.cost_alerts.arn
}

output "sqs_events_queue_url" {
  description = "URL of the main SQS queue"
  value       = aws_sqs_queue.events.url
}

output "sqs_dlq_url" {
  description = "URL of the Dead Letter Queue"
  value       = aws_sqs_queue.dlq.url
}

output "collector_role_arn" {
  description = "ARN of the IAM Role for the Lambda Collector"
  value       = aws_iam_role.collector.arn
}

output "schedule_rule_name" {
  description = "Name of the scheduling EventBridge rule"
  value       = aws_cloudwatch_event_rule.schedule.name
}

output "collector_function_name" {
  description = "Name of Lambda Collector"
  value       = aws_lambda_function.collector.function_name
}
