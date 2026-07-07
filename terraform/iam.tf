# iam.tf - IAM role & policy for Lambda (Least Privilege)
# Role for Lambda collector: Only allowed to call Cost Explorer + write to S3 + write logs

# Trust policy: Allow Lambda service to assume this role
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Role for Lambda collector
resource "aws_iam_role" "collector" {
  name               = "${var.project_name}-collector-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Minimum permissions for collector
data "aws_iam_policy_document" "collector_policy" {
  # Call Cost Explorer API to get cost data
  statement {
    sid       = "CostExplorerRead"
    effect    = "Allow"
    actions   = ["ce:GetCostAndUsage"]
    resources = ["*"]
  }

  # Write cost data to the correct bucket
  statement {
    sid       = "S3WriteCostData"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cost_data.arn}/*"]
  }

  # Write logs to CloudWatch
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

resource "aws_iam_role_policy" "collector" {
  name   = "${var.project_name}-collector-policy"
  role   = aws_iam_role.collector.id
  policy = data.aws_iam_policy_document.collector_policy.json
}