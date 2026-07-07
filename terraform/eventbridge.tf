# eventbridge.tf - lập lịch chạy định kì cho lambda collector

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.project_name}-schedule"
  description         = "Trigger the Lambda Collector periodically to collect cost data"
  schedule_expression = var.schedule_expression
}