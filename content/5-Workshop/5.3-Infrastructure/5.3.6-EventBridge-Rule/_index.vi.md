---
title : "Tạo EventBridge Rule lập lịch"
date : 2024-01-01 
weight : 6
chapter : false
pre : " <b> 5.3.6 </b> "
---

Tiếp theo, chúng ta sẽ tạo file `terraform/eventbridge.tf`. File này được sử dụng để cấu hình dịch vụ **Amazon EventBridge**, trước đây là **CloudWatch Event** nhằm mục đích lập lịch tự động cho hệ thống.

Hàm Lambda Collector dùng để lấy dữ liệu chi phí sẽ không thể tự động chạy trừ khi có một sự kiện kích hoạt nó. Để hệ thống **CloudCost Insight** có thể liên tục theo dõi và cập nhật chi phí mỗi ngày mà không cần con người can thiệp, chúng ta cần một công cụ lập lịch để có thể tự động kích hoạt nó mỗi ngày.

Dựa trên lịch trình mà chúng ta đã cấu hình (1 lần/ngày ở biến `schedule_expression`), EventBridge sẽ tự động kích hoạt hàm **Lambda Collector** đi lấy dữ liệu chi phí, đồng thời file này cung cấp quyền để **EventBridge** được phép gọi hàm Lambda.

```hcl
# Lập lịch 1 lần/ngày
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.project_name}-schedule"
  description         = "Trigger the Lambda Collector periodically to collect cost data"
  schedule_expression = var.schedule_expression
}
```

#### Nội dung tiếp theo

- [Khai báo Outputs](../5.3.7-Outputs/)

