# Lambda API + HTTP API Gateway cho Web dashboard
# Expose Lambda API thành endpoint HTTP để web frontend gọi lấy dữ liệu chi phí

# IAM role cho Lambda API
resource "aws_iam_role" "api" {
  name               = "${var.project_name}-api-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "api_policy" {
  # đọc dữ liệu chi phí từ s3
  statement {
    sid     = "S3ReadCostData"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.cost_data.arn,
      "${aws_s3_bucket.cost_data.arn}/*"
    ]
  }

  # ghi log Cloudwatch
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

resource "aws_iam_role_policy" "api" {
  name   = "${var.project_name}-api-policy"
  role   = aws_iam_role.api.id
  policy = data.aws_iam_policy_document.api_policy.json
}

# đóng gói code lambda api
data "archive_file" "api_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/api"
  output_path = "${path.module}/build/api.zip"
}

# log group
resource "aws_cloudwatch_log_group" "api" {
  name              = "/aws/lambda/${var.project_name}-api"
  retention_in_days = 14
}

# Lambda API function
resource "aws_lambda_function" "api" {
  function_name = "${var.project_name}-api"
  role          = aws_iam_role.api.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"
  timeout       = 30
  memory_size   = 128

  filename         = data.archive_file.api_zip.output_path
  source_code_hash = data.archive_file.api_zip.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME        = aws_s3_bucket.cost_data.id
      COST_THRESHOLD_USD = var.cost_threshold_usd
      SPIKE_MULTIPLIER   = var.spike_multiplier
      MAX_DAYS           = "30"
    }
  }

  depends_on = [aws_cloudwatch_log_group.api]
}

# HTTP API gateway
resource "aws_apigatewayv2_api" "dashboard" {
  name          = "${var.project_name}-api"
  protocol_type = "HTTP"
  description   = "API provides cost data for the Web Dashboard"

  # bật CORS để web frontend gọi được
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "OPTIONS"]
    allow_headers = ["Content-Type"]
  }
}

# tích hợp API gateway với lambda
resource "aws_apigatewayv2_integration" "api" {
  api_id                 = aws_apigatewayv2_api.dashboard.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api.invoke_arn
  payload_format_version = "2.0"
}

# route: get/costs
resource "aws_apigatewayv2_route" "costs" {
  api_id    = aws_apigatewayv2_api.dashboard.id
  route_key = "GET /costs"
  target    = "integrations/${aws_apigatewayv2_integration.api.id}"
}

# state mặc định (tự động deploy)
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.dashboard.id
  name        = "$default"
  auto_deploy = true
}

# cho phép API gateway gọi lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.dashboard.execution_arn}/*/*"
}
