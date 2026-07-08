# eventbridge.tf - lập lịch chạy định kì cho lambda collector

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.project_name}-schedule"
  description         = "Trigger the Lambda Collector periodically to collect cost data"
  schedule_expression = var.schedule_expression
}

# Trỏ rule tới hàm lambda collector
resource "aws_cloudwatch_event_target" "collector" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "collector-lambda"
  arn       = aws_lambda_function.collector.arn
}

# Cho phép EventBridge được gọi Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.collector.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}