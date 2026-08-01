# Host Website lên S3 + CloudFront

# S3 bucket lưu web tĩnh
resource "aws_s3_bucket" "web" {
  bucket = "${var.project_name}-web-${data.aws_caller_identity.current.account_id}"
}

# static website hosting
resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.web.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

# CloudFront + Origin Access Control 
resource "aws_cloudfront_origin_access_control" "web" {
  name                              = "${var.project_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# chặn truy cập public trực tiếp vào bucket
resource "aws_s3_bucket_public_access_block" "web" {
  bucket                  = aws_s3_bucket.web.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "web" {
  enabled             = true
  default_root_object = "index.html"
  comment             = "CloudCost Insight Web Dashboard"

  origin {
    domain_name              = aws_s3_bucket.web.bucket_regional_domain_name
    origin_id                = "s3-web"
    origin_access_control_id = aws_cloudfront_origin_access_control.web.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-web"
    viewer_protocol_policy = "redirect-to-https" # HTTPS
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100" #cheap
}

# bucket policy: Cloudfront đọc S3
data "aws_iam_policy_document" "web_bucket_policy" {
  statement {
    sid       = "AllowCloudFrontRead"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.web.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.web.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "web" {
  bucket = aws_s3_bucket.web.id
  policy = data.aws_iam_policy_document.web_bucket_policy.json
}

# upload index.html lên S3
resource "aws_s3_object" "index" {
  bucket        = aws_s3_bucket.web.id
  key           = "index.html"
  source        = "${path.module}/web/index.html"
  content_type  = "text/html"
  cache_control = "no-cache, no-store, must-revalidate"
  etag          = filemd5("${path.module}/web/index.html")
}

# upload style.css lên S3
resource "aws_s3_object" "style" {
  bucket        = aws_s3_bucket.web.id
  key           = "style.css"
  source        = "${path.module}/web/style.css"
  content_type  = "text/css"
  cache_control = "no-cache, no-store, must-revalidate"
  etag          = filemd5("${path.module}/web/style.css")
}

# upload script.js lên S3
locals {
  rendered_script = replace(
    replace(
      replace(
        file("${path.module}/web/script.js"),
        "REPLACE_MY_API_ENDPOINT",
        "${trim(aws_apigatewayv2_stage.default.invoke_url, "/")}/costs"
      ),
      "REPLACE_MY_COGNITO_DOMAIN",
      "https://${aws_cognito_user_pool_domain.dashboard.domain}.auth.${var.aws_region}.amazoncognito.com"
    ),
    "REPLACE_MY_COGNITO_CLIENT_ID",
    aws_cognito_user_pool_client.dashboard.id
  )
}

resource "aws_s3_object" "script" {
  bucket = aws_s3_bucket.web.id
  key    = "script.js"

  content       = local.rendered_script
  content_type  = "application/javascript"
  cache_control = "no-cache, no-store, must-revalidate"
  etag          = md5(local.rendered_script)
}