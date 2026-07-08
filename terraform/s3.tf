# S3: Store cost data
# Security: Block public access + Enable encryption + Enable versioning

resource "aws_s3_bucket" "cost_data" {
  bucket        = "${var.project_name}-cost-data-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "cost_data" {
  bucket = aws_s3_bucket.cost_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "cost_data" {
  bucket = aws_s3_bucket.cost_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning to prevent data loss
resource "aws_s3_bucket_versioning" "cost_data" {
  bucket = aws_s3_bucket.cost_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle: Move old data to cheaper storage class to optimize cost
resource "aws_s3_bucket_lifecycle_configuration" "cost_data" {
  bucket = aws_s3_bucket.cost_data.id

  rule {
    id     = "archive-old-cost-data"
    status = "Enabled"

    filter {}

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }
  }
}

# Get current account ID to ensure unique bucket name
data "aws_caller_identity" "current" {}