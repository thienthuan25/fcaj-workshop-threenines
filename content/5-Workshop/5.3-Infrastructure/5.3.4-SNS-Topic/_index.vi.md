---
title : "Tạo SNS Topic cảnh báo"
date : 2024-01-01 
weight : 4
chapter : false
pre : " <b> 5.3.4 </b> "
---

Tiếp theo, chúng ta sẽ tạo file `sns.tf`, file này được sử dụng để khởi tạo dịch vụ thông báo **Amazon Simple Notification Service** (SNS). Nhiệm vụ chính của file này là tạo ra một kênh giao tiếp và kết nối nó với địa chỉ email của bạn.

Mục đích cốt lõi của hệ thống **CloudCost Insight** là phát hiện khoản chi phí bất thường và cảnh báo kịp thời cho người quản trị. Tuy nhiên, Lambda không tự mình gửi email được. Do đó, chúng ta cần SNS làm cầu nối:

- Tạo Topic
- Subcription
- Bảo mật

```hcl
# Tạo một topic làm nơi tập trung để phát đi các cảnh báo chi phí
resource "aws_sns_topic" "cost_alerts" {
  name = "${var.project_name}-cost-alerts"
}

# Đăng kí nhận tin để hệ thống gửi email mỗi khi có cảnh báo
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.cost_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Chỉ cho phép duy nhất tài khoản AWS của bạn và dịch vụ giám sát CloudWatch được quyền đẩy thông báo vào Topic này
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

#### Nội dung tiếp theo

