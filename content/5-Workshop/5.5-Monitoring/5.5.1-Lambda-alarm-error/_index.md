---
title : "Configure CloudWatch Alarms for Lambda"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.5.1 </b> "
---

In this section, we will create the `lambda/cloudwatch_alarms.tf` file. We will first configure two CloudWatch Alarms to monitor the `Errors` metric of the **Lambda Collector** and **Lambda Analyzer** functions. Whenever the number of errors exceeds 0 during the evaluation period, the alarm is triggered and sends a notification through SNS.

```hcl
# Alarm when Lambda Collector encounters an error
resource "aws_cloudwatch_metric_alarm" "collector_errors" {
  alarm_name          = "${var.project_name}-collector-errors"
  alarm_description   = "Alarm when Lambda Collector encounters an error"
  namespace           = "AWS/Lambda" # Metric namespace
  metric_name         = "Errors"   # Error count metric
  statistic           = "Sum"    # Sum of error occurrences
  comparison_operator = "GreaterThanThreshold" # Trigger when the metric exceeds the threshold
  threshold           = 0        # Error threshold
  period              = 300      # 5 minutes
  evaluation_periods  = 1        # Trigger immediately after one evaluation period exceeds the threshold
  treat_missing_data  = "notBreaching" # If no error data is available, the alarm remains in the OK state to avoid false alarms when the system is not running continuously

  dimensions = {
    FunctionName = aws_lambda_function.collector.function_name # Applied to the Lambda Collector function
  }

  alarm_actions = [aws_sns_topic.cost_alerts.arn] # Send notifications through SNS
  ok_actions    = [aws_sns_topic.cost_alerts.arn] # Send a notification when the alarm returns to the OK state
}

# Alarm when Lambda Analyzer encounters an error
resource "aws_cloudwatch_metric_alarm" "analyzer_errors" {
  alarm_name          = "${var.project_name}-analyzer-errors"
  alarm_description   = "Alarm when Lambda Analyzer encounters an error"
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  period              = 300 # 5 minutes
  evaluation_periods  = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.analyzer.function_name
  }

  alarm_actions = [aws_sns_topic.cost_alerts.arn]
  ok_actions    = [aws_sns_topic.cost_alerts.arn]
}
```

#### Next

- [Configure CloudWatch Alarms for the SQS Dead Letter Queue](../5.5.2-Lambda-DLQ-error/)