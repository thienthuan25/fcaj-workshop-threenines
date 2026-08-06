---
title : "Cấu hình CloudWatch Alarms cho Dead Letter Queue"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.5.2 </b> "
---

**1.** Tiếp theo, trong cùng một file `terraform/cloudwatch_alarms.tf`, chúng ta thêm một Alarm giám sát **Dead Letter Queue**. Alarm này theo dõi số lượng message trong DLQ, và được kích hoạt khi có bất kì message lỗi nào rơi vào đây.

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

Alarm này sử dụng metric `ApproximateNumberOfMessagesVisible` của Dead Letter Queue. Khi hệ thống hoạt động bình thường, DLQ luôn trống. Vì vậy, chỉ cần một message xuất hiện, Alarm sẽ kích hoạt và báo cho bạn biết, có sự kiện đã xử lý thất bại cần điều tra.

**2.** Mở file `terraform/outputs.tf` và thêm cấu hình sau vào cuối file:

```hcl
# Hệ thống giám sát lỗi (CloudWatch Alarms)
# Xuất tên của các loại cảnh báo ra màn hình sau khi triển khai
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
```

#### Nội dung tiếp theo

- [Triển khai](../5.5.3-Deploy)