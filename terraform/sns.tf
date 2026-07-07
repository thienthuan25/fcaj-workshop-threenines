# sns.tf - Topic for sending cost alerts + email subscription

resource "aws_sns_topic" "cost_alerts" {
  name = "${var.project_name}-cost-alerts"
}

# Subscribe email to receive alerts
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.cost_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Policy allowing only services within the account to publish to the topic
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
      }
    ]
  })
}
