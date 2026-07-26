---
title : "Khai báo Outputs"
date : 2024-01-01 
weight : 7
chapter : false
pre : " <b> 5.3.7 </b> "
---

Tiếp theo, chúng ta sẽ tạo file `lambda/outputs.tf`. Đây là phần cuối cùng trong phần xây dựng hạ tầng nền. File này được sử dụng để định nghĩa các giá trị đầu ra sau khi Terraform chạy xong.

Khi Terraform triển khai xong hạ tầng trên AWS, nó sẽ tạo ra rất nhiều tài nguyên với các thông số ngẫu nhiên. Ví dụ:

- Tên S3 bucket có gắn Account ID.
- Đường dẫn URL của SQS.
- Đường link của API Gateway và CloudFront.

Thay vì chúng ta phải vào cửa sổ AWS Console, bấm vào từng dịch vụ một cách thủ công để tìm kiếm và copy những đường link đó, file `outputs.tf` sẽ yêu cầu Terraform in trực tiếp tất cả các thông tin quan trọng này ra màn hình Terminal ngay sau khi quá trình triển khai hoàn tất. Điều này giúp chúng ta dễ dàng lấy thông tin để cấu hình cho bước tiếp theo hoặc để truy cập nhanh vào trang Web Dashboard.

```hcl
# Bucket lưu trữ dữ liệu
output "cost_data_bucket_name" {
  description = "Name of the S3 bucket storing cost data"
  value       = aws_s3_bucket.cost_data.id
}


output "cost_data_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.cost_data.arn
}

# Gửi thông báo (SNS)
output "sns_topic_arn" {
  description = "ARN of the SNS topic for sending alerts"
  value       = aws_sns_topic.cost_alerts.arn
}

# Hàng đợi (SQS)
output "sqs_events_queue_url" {
  description = "URL of the main SQS queue"
  value       = aws_sqs_queue.events.url
}

output "sqs_dlq_url" {
  description = "URL of the Dead Letter Queue"
  value       = aws_sqs_queue.dlq.url
}

# Các hàm Lambda và lập lịch
output "collector_role_arn" {
  description = "ARN of the IAM Role for the Lambda Collector"
  value       = aws_iam_role.collector.arn
}

output "schedule_rule_name" {
  description = "Name of the scheduling EventBridge rule"
  value       = aws_cloudwatch_event_rule.schedule.name
}
```

#### Nội dung tiếp theo

- [Triển khai hạ tầng](../5.3.8-Deploy-infrastructure/)

