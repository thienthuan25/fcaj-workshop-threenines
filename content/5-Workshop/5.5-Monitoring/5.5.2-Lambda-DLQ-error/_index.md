---
title : "Configure CloudWatch Alarms for the Dead Letter Queue"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.5.2 </b> "
---

Next, in the same `lambda/cloudwatch_alarms.tf` file, we will add a CloudWatch Alarm to monitor the **Dead Letter Queue**. This alarm tracks the number of messages in the DLQ and is triggered whenever any failed message is placed into the queue.

```hcl
# Alarm when messages are sent to the Dead Letter Queue
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

This alarm uses the `ApproximateNumberOfMessagesVisible` metric of the Dead Letter Queue. Under normal operating conditions, the DLQ should always remain empty. Therefore, as soon as a single message appears in the queue, the alarm is triggered to notify you that a processing failure has occurred and requires investigation.

#### Next

- [Deployment](../5.5.3-Deploy)