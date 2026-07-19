---
title : "Tạo IAM Role cho Lambda"
date : 2024-01-01 
weight : 3
chapter : false
pre : " <b> 5.3.3 </b> "
---

Chúng ta sẽ tạo file `iam.tf` để định nghĩa **Quyền truy cập** (IAM Role và IAM Policy) dành riêng cho một hàm Lambda (được gọi là Lambda Collector).

Trên nền tảng AWS, các dịch vụ (như Lambda) theo mặc định không có quyền tương tác với bất kỳ tài nguyên AWS nào khác. Để hàm Lambda có thể hoạt động, chúng ta bắt buộc phải cấp quyền một các tường minh cho nó. Thay vì cấp cho Lambda một quyền truy cập tất cả (Administrator), thì chúng ta chỉ cung cấp vừa đủ các quyền hạn cần thiết để Lambda hoàn thành đúng nhiệm vụ của nó. Cụ thể:

- Đọc dữ liệu từ dịch vụ tính phí **AWS Cost Explorer**.
- Ghi kết quả vào đúng cái **S3 Bucket** mà chúng ta đã tạo trước đó.
- gửi message vào một hàng đợi **SQS**.
- Ghi lại logs lên dịch vụ **CloudWatch**.

```hcl
# Định nghĩa Trust Policy cho phép dịch vụ AWS Lambda có quyền assume vào role
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Khởi tạo một IAM Role mới dành riêng cho hàm Lambda Collector.
resource "aws_iam_role" "collector" {
  name               = "${var.project_name}-collector-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Định nghĩa chi tiết các quyền tuần theo nguyên tắc Least Privilege 
data "aws_iam_policy_document" "collector_policy" {
  # Call Cost Explorer API to get cost data
  statement {
    sid       = "CostExplorerRead"  # cấp quyền đọc Cost Explorer
    effect    = "Allow"
    actions   = ["ce:GetCostAndUsage"]
    resources = ["*"]
  }

  # Write cost data to the correct bucket
  statement {
    sid       = "S3WriteCostData" # ghi dữ liệu vào S3 Bucket
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cost_data.arn}/*"]
  }

  # Send message to SQS
  statement {
    sid       = "SQSSendMessage" # gửi message vào SQS
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = ["${aws_sqs_queue.events.arn}"]
  }

  # Write logs to CloudWatch
  statement {
    sid    = "CloudWatchLogs" # ghi logs lên CloudWatch
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# Gán IAM Policy vừa tạo vào IAM Role
resource "aws_iam_role_policy" "collector" {
  name   = "${var.project_name}-collector-policy"
  role   = aws_iam_role.collector.id
  policy = data.aws_iam_policy_document.collector_policy.json
}
```

#### Nội dung tiếp theo

[Tạo SNS Topic cảnh báo](../5.3.4-SNS-Topic/)