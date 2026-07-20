---
title : "Khai báo các biến đầu vào"
date : 2024-01-01 
weight : 1
chapter : false
pre : " <b> 5.3.1 </b> "
---

Trước tiên, chúng ta tạo file `variables.tf` để khai báo các biến dùng chung cho toàn bộ dự án. Việc tách biến ra riêng giúp dễ tùy chỉnh mà không phải sửa trực tiếp trong code tài nguyên.

```hcl
# Khai báo region của AWS mà các tài nguyên hạ tầng sẽ được triển khai
variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

# Xác định môi trường triển khai hiện tại của hệ thống
variable "environment" {
  description = "Deployment environment (dev/test/prod)"
  type        = string
  default     = "dev"
}

# Tên của dự án, được sử dụng làm tiền tố khi đặt tên cho các tài nguyên (như Lambda, S3, IAM Role...)
variable "project_name" {
  description = "Project name, used as a prefix for naming resources"
  type        = string
  default     = "cloudcost-insight"
}

# Địa chỉ Email sẽ nhận được thông báo khi hệ thống gửi cảnh báo
variable "alert_email" {
  description = "Email address for receiving cost alert via SNS"
  type        = string

}

# Định nghĩa một biểu thức lịch trình dành cho dịch vụ AWS EventBridge để xác định tần suất chạy của một tác vụ tự động
variable "schedule_expression" {
  description = "Scheduled expression for EventBridge"
  type        = string
  default     = "rate(1 day)"
}

# Đặt ra mức hạn chi phí bằng đơn vị USD
variable "cost_threshold_usd" {
  description = "Cost threshold (USD) that triggers an alert"
  type        = number
  default     = 10
}
```

#### Nội dung tiếp theo

- [Tạo S3 Bucket lưu dữ liệu chi phí](../5.3.2-S3-bucket/)


