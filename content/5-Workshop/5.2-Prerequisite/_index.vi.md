---
title : "Các bước chuẩn bị"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---


#### Yêu cầu chung

Trước khi bắt đầu workshop, bạn cần chuẩn bị các điều kiện sau:

+ Một tài khoản AWS đã được kích hoạt AWS Cost Explorer (Cost Explorer cần được bật trong Billing để có thể gọi API lấy dữ liệu chi phí).
+ Region sử dụng trong workshop này là N. Virginia (us-east-1).
+ Một tài khoản HCP Terraform (app.terraform.io) để quản lý remote state.

#### Công cụ cần cài đặt

+ **Terraform** (phiên bản 1.5 trở lên) để triển khai hạ tầng dưới dạng Infrastructure as Code.
+ **AWS CLI** để thao tác và kiểm thử với các dịch vụ AWS từ dòng lệnh.
+ **Python** (phiên bản 3.12) để phát triển các hàm Lambda.
+ Một trình soạn thảo mã nguồn như Visual Studio Code.

#### IAM permissions

Gắn IAM permission policy sau vào tài khoản AWS user của bạn để có đủ quyền triển khai và dọn dẹp tài nguyên trong workshop này. Đây là bộ quyền tối thiểu cho các dịch vụ mà CloudCost Insight sử dụng.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudCostInsightDeploy",
      "Effect": "Allow",
      "Action": [
        "lambda:*",
        "s3:*",
        "sqs:*",
        "sns:*",
        "events:*",
        "cloudwatch:*",
        "logs:*",
        "apigateway:*",
        "cloudfront:*",
        "ce:GetCostAndUsage",
        "secretsmanager:CreateSecret",
        "secretsmanager:DeleteSecret",
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutSecretValue",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:PassRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:GetRolePolicy",
        "iam:CreatePolicy",
        "iam:DeletePolicy",
        "iam:GetPolicy",
        "iam:ListRoles",
        "iam:ListPolicyVersions"
      ],
      "Resource": "*"
    }
  ]
}
```

#### Nội dung

- [Cấu hình AWS Credentials](5.2.1-AWS-Credentials/)
- [Cấu hình HCP Terraform](5.2.2-HCP-Terraform/)    
- [Chuẩn bị Code Terraform](5.2.3-Code-terraform/)