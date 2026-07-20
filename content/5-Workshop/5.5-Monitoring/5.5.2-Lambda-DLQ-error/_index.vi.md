---
title : "Cấu hình CloudWatch Alarm cho Lambda"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.5.2 </b> "
---

```hcl
# Cảnh báo khi có tin nhắn rơi vào Dead Letter Queue
resource "aws_cloudwatch_metric_alarm" "dlq_message" {
  alarm_name          = "${var.project_name}-dlq-has-messages"
  alarm_description   = "Alarm when DLQ has messages"
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  period              = 300
  evaluation_periods  = 1
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.dlq.name
  }

  alarm_actions = [aws_sns_topic.cost_alerts.arn]
  ok_actions    = [aws_sns_topic.cost_alerts.arn]
}
```