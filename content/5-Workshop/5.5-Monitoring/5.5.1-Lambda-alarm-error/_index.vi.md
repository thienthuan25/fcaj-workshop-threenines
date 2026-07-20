---
title : "Cấu hình CloudWatch Alarm cho Lambda"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.5.1 </b> "
---

Trong phần này, chúng ta sẽ tạo file `lambda/cloudwatch_alarms.tf`. Trước tiên là hai Alarm giám sát metric `Errors` của hai hàm **Lambda Collector** và **Lambda Analyzer**. Khi số lỗi lớn hơn 0 trong khoảng thời gian đánh giá, Alarm sẽ kích hoạt và gửi thông báo qua SNS.

```hcl
# Cảnh báo khi Lambda Collector lỗi
resource "aws_cloudwatch_metric_alarm" "collector_errors" {
  alarm_name          = "${var.project_name}-collector-errors"
  alarm_description   = "Alarm when Lambda Collector encounters an error"
  namespace           = "AWS/Lambda" # Không gian tên metric
  metric_name         = "Errors"   # Metric số lượng lỗi
  statistic           = "Sum"    # Tính tổng số lượng lỗi
  comparison_operator = "GreaterThanThreshold" # Kích hoạt khi giá trị lớn hơn ngưỡng
  threshold           = 0        # Ngưỡng số lượng lỗi
  period              = 300      # 5 phút
  evaluation_periods  = 1        # 1 lần vi phạm là báo ngay
  treat_missing_data  = "notBreaching" # Nếu không có dữ liệu lỗi nào, Alarm sẽ ở trạng thái OK, giúp tránh báo động giả khi hệ thống không hoạt động liên tục

  dimensions = {
    FunctionName = aws_lambda_function.collector.function_name # áp dụng cho hàm Lambda Collector
  }

  alarm_actions = [aws_sns_topic.cost_alerts.arn] # gửi thông báo qua SNS
  ok_actions    = [aws_sns_topic.cost_alerts.arn] # gửi thông báo qua SNS khi hết lỗi
}

# Alarm 2: Lambda Analyzer lỗi
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

#### Nội dung tiếp theo

- [Cấu hình CloudWatch Alarm cho SQS DLQ](../5.5.2-Lambda-DLQ-error/)