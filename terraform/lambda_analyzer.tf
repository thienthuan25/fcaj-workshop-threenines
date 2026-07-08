# IAM role cho Analyzer 
resource "aws_iam_role" "analyzer" {
  name               = "${var.project_name}-analyzer-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "analyzer_policy" {
  # đọc dữ liệu chi phí từ S3
  statement {
    sid       = "S3ReadCostData"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cost_data.arn}/*"]
  }

  # nhận & xóa message từ SQS chính 
  statement {
    sid    = "SQSConsume"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    resources = [aws_sqs_queue.events.arn]
  }

  # publish cảnh báo qua SNS
  statement {
    sid       = "SNSPublish"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.cost_alerts.arn]
  }

  # ghi log lên CloudWatch
  statement {
    sid    = "CloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "analyzer" {
  name   = "${var.project_name}-analyzer-policy"
  role   = aws_iam_role.analyzer.id
  policy = data.aws_iam_policy_document.analyzer_policy.json
}

# đóng gói code
data "archive_file" "analyzer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/analyzer"
  output_path = "${path.module}/build/analyzer.zip"
}

# log group
resource "aws_cloudwatch_log_group" "analyzer" {
  name              = "/aws/lambda/${var.project_name}-analyzer"
  retention_in_days = 14
}

# lambda analyzer function
resource "aws_lambda_function" "analyzer" {
  function_name = "${var.project_name}-analyzer"
  role          = aws_iam_role.analyzer.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
  timeout       = 60
  memory_size   = 128

  filename         = data.archive_file.analyzer_zip.output_path
  source_code_hash = data.archive_file.analyzer_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME        = aws_s3_bucket.cost_data.id
      SNS_TOPIC_ARN      = aws_sns_topic.cost_alerts.arn
      COST_THRESHOLD_USD = var.cost_threshold_usd
    }
  }

  depends_on = [aws_cloudwatch_log_group.analyzer]
}

# kết nối SQS -> lambda analyzer 
resource "aws_lambda_event_source_mapping" "sqs_to_analyzer" {
  event_source_arn = aws_sqs_queue.events.arn
  function_name    = aws_lambda_function.analyzer.arn
  batch_size       = 10
  enabled           = true
}