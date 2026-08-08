---
title : "Các bước chuẩn bị"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

### Yêu cầu chung

Trước khi bắt đầu workshop, bạn cần chuẩn bị các điều kiện sau:

- Một tài khoản AWS có quyền tạo và xóa tài nguyên.
- Region sử dụng trong workshop này là N. Virginia (`us-east-1`).
- Đã bật AWS Cost Explorer trong AWS Billing Console. Lưu ý dữ liệu Cost Explorer có thể có độ trễ, vì vậy workshop có sử dụng thêm dữ liệu chi phí mô phỏng để kiểm thử.
- Một tài khoản HCP Terraform tại [app.terraform.io](https://app.terraform.io) để quản lý remote state và thực hiện Terraform remote run.
- Một tài khoản GitHub và một GitHub repository để lưu trữ mã nguồn, tạo Pull Request và cấu hình CI/CD.
- Một địa chỉ email có thể nhận email từ Amazon SNS để kiểm thử cảnh báo chi phí và cảnh báo sự cố.

### Công cụ cần cài đặt

- **Git** để quản lý mã nguồn, tạo branch, commit và push code lên GitHub.
- **Terraform** (phiên bản 1.5 trở lên) để triển khai hạ tầng dưới dạng Infrastructure as Code.
- **AWS CLI** để cấu hình AWS credentials, thao tác và kiểm thử các dịch vụ AWS từ dòng lệnh.
- **Python** (phiên bản 3.12) để phát triển, chạy unit test và kiểm tra các hàm Lambda.
- **Node.js** để kiểm tra cú pháp JavaScript của Web Dashboard.
- **Hugo Extended** nếu bạn muốn chạy và kiểm tra Workshop trên máy local trước khi push lên GitHub Pages.
- Một trình soạn thảo mã nguồn như Visual Studio Code.

### IAM permissions

Gắn IAM permission policy sau vào AWS IAM User hoặc IAM Role dùng để triển khai workshop. Policy này cấp quyền cho các dịch vụ được CloudCost Insight sử dụng, bao gồm Lambda, S3, SQS, SNS, EventBridge, CloudWatch, API Gateway, CloudFront và Amazon Cognito.

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
        "cognito-idp:*",
        "ce:GetCostAndUsage",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:PassRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:GetRolePolicy",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:TagRole",
        "iam:UntagRole",
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

## Nội dung

1. [Cấu hình AWS Credentials](5.2.1-AWS-Credentials/)
2. [Cấu hình HCP Terraform](5.2.2-HCP-Terraform/)
3. [Chuẩn bị Code Terraform](5.2.3-Code-terraform/)