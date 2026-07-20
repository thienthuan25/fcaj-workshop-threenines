---
title : "Cấu hình CloudWatch Alarm cho Lambda"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.5.2 </b> "
---

Tiếp theo, trong cùng một file `lambda/cloudwatch_alarms.tf`, chúng ta thêm một Alarm giám sát **Dead Letter Queue**. Alarm này theo dõi số lượng message trong DLQ, và được kích hoạt khi có bất kì message lỗi nào rơi vào đây.

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

#### Nội dung tiếp theo

- [Triển khai](../5.5.3-Deploy)