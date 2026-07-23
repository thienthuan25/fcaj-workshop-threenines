---
title : "Create an Amazon EventBridge Schedule"
date : 2024-01-01
weight : 6
chapter : false
pre : " <b> 5.3.6 </b> "
---

Next, we will create the `eventbridge.tf` file. This file configures **Amazon EventBridge**, formerly known as **Amazon CloudWatch Events**, to provide automated scheduling for the system.

The Lambda Collector function that retrieves cost data cannot run automatically unless it is triggered by an event. To enable **CloudCost Insight** to continuously monitor and update AWS cost data every day without manual intervention, we need a scheduling service that can invoke the function automatically on a daily basis.

Based on the schedule defined in the `schedule_expression` variable, which is once per day by default, Amazon EventBridge automatically invokes the **Lambda Collector** function to collect cost data. This file also grants EventBridge permission to invoke Lambda function.

```hcl
# Schedule the Lambda function to run once per day.
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.project_name}-schedule"
  description         = "Trigger the Lambda Collector periodically to collect cost data"
  schedule_expression = var.schedule_expression
}

# Invoke the Lambda Collector function when the scheduled time is reached.
resource "aws_cloudwatch_event_target" "collector" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "collector-lambda"
  arn       = aws_lambda_function.collector.arn
}

# Grant Amazon EventBridge permission to invoke the Lambda function.
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.collector.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}
```

#### Next Content

- [Define Terraform Outputs](../5.3.7-Outputs/)

