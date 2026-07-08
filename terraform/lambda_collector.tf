# lambda_collector.tf - Hàm Lambda Collector + đóng gói code

# Đóng gói code Python thành file zip
data "archive_file" "collector_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/collector"
  output_path = "${path.module}/build/collector.zip"
}

# Log group cho Lambda (đặt retention để tránh tốn chi phí log)
resource "aws_cloudwatch_log_group" "collector" {
  name              = "/aws/lambda/${var.project_name}-collector"
  retention_in_days = 14
}

# Hàm Lambda Collector
resource "aws_lambda_function" "collector" {
  function_name = "${var.project_name}-collector"
  role          = aws_iam_role.collector.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
  timeout       = 60
  memory_size   = 128

  filename         = data.archive_file.collector_zip.output_path
  source_code_hash = data.archive_file.collector_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.cost_data.id
      QUEUE_URL   = aws_sqs_queue.events.url
    }
  }

  depends_on = [aws_cloudwatch_log_group.collector]
}