---
title: "Worklog Tuần 6"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.6. </b> "
---

### Mục tiêu tuần 6:

* Phát triển hàm Lambda Collector — thành phần thu thập dữ liệu chi phí của hệ thống CloudCost Insight.
* Tích hợp AWS Cost Explorer API để lấy dữ liệu chi phí sử dụng dịch vụ AWS theo ngày.
* Ghi dữ liệu chi phí vào S3 (phân vùng theo ngày) và đẩy sự kiện vào SQS để phục vụ khâu phân tích.
* Triển khai Lambda bằng Terraform, nối với EventBridge để tự động hóa việc thu thập định kỳ.
* Kiểm chứng luồng thu thập dữ liệu end-to-end (Lambda → Cost Explorer → S3 → SQS).

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Nghiên cứu Cost Explorer API & thiết kế hàm: <br>&emsp; + Tìm hiểu API `GetCostAndUsage`, các tham số TimePeriod, Granularity, Metrics, GroupBy. <br>&emsp; + Xác định lấy dữ liệu chi phí của ngày hôm trước (do Cost Explorer có độ trễ tới 24h). <br>&emsp; + Thiết kế cấu trúc dữ liệu và cách phân vùng lưu trữ trên S3. | 15/06/2026 | 15/06/2026 | - AWS Cost Explorer API (GetCostAndUsage): <br> https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_GetCostAndUsage.html |
| 3 | - Viết code Lambda Collector (Python + boto3): <br>&emsp; + Viết hàm gọi Cost Explorer API lấy chi phí theo từng dịch vụ. <br>&emsp; + Viết hàm ghi dữ liệu JSON vào S3 (phân vùng year/month/day). <br>&emsp; + Viết hàm đẩy sự kiện (tổng chi phí, khóa S3) vào SQS. | 16/06/2026 | 16/06/2026 | - Boto3 Cost Explorer Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ce.html <br> - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html |
| 4 | - Viết Terraform triển khai Lambda: <br>&emsp; + Viết `lambda_collector.tf`: đóng gói code (archive_file), tạo hàm Lambda, log group với retention. <br>&emsp; + Truyền cấu hình qua biến môi trường (BUCKET_NAME, QUEUE_URL) thay vì hard-code. | 17/06/2026 | 17/06/2026 | - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function <br> - Terraform archive_file: <br> https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file |
| 5 | - Nối EventBridge & cập nhật quyền IAM: <br>&emsp; + Cập nhật `eventbridge.tf`: nối rule lập lịch tới Lambda (target + lambda_permission). <br>&emsp; + Bổ sung quyền `sqs:SendMessage` vào IAM Role Collector (giữ nguyên tắc Least Privilege). <br>&emsp; + Chạy `terraform apply` triển khai Lambda lên AWS. | 18/06/2026 | 18/06/2026 | - Terraform aws_cloudwatch_event_target: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target <br> - EventBridge with Lambda: <br> https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-use-resource-based.html |
| 6 | - Kiểm thử & xác minh luồng thu thập: <br>&emsp; + Test thủ công Lambda Collector trên Console (test event rỗng). <br>&emsp; + Kiểm tra CloudWatch Logs xác nhận Lambda chạy đúng. <br>&emsp; + Xác minh dữ liệu chi phí đã ghi vào S3 và sự kiện đã vào SQS. | 19/06/2026 | 19/06/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Amazon CloudWatch Logs. |

### Kết quả đạt được tuần 6:

* **Hoàn thành thành phần thu thập dữ liệu (Collector):** Đã phát triển thành công hàm Lambda Collector bằng Python và boto3, tích hợp trực tiếp với AWS Cost Explorer API để tự động lấy dữ liệu chi phí sử dụng dịch vụ theo ngày. Đây là mắt xích đầu tiên trong luồng dữ liệu của hệ thống CloudCost Insight.

* **Thiết kế lưu trữ khoa học:** Dữ liệu chi phí được ghi vào S3 dưới dạng JSON và phân vùng theo cấu trúc year/month/day, giúp việc truy vấn và trực quan hóa (dashboard) ở các giai đoạn sau thuận tiện và tối ưu.

* **Tự động hóa và tách rời (decoupling):** Đã triển khai Lambda bằng Terraform và nối với EventBridge để hệ thống tự động thu thập dữ liệu định kỳ mà không cần thao tác thủ công. Collector đẩy sự kiện vào SQS để tách rời khâu thu thập và phân tích, tăng tính linh hoạt và độ bền cho hệ thống.

* **Tuân thủ bảo mật và cấu hình động:** Bổ sung quyền `sqs:SendMessage` cho IAM Role theo đúng nguyên tắc Least Privilege. Toàn bộ cấu hình (tên bucket, URL hàng đợi) được truyền qua biến môi trường thay vì hard-code, tuân thủ best practice bảo mật của AWS.

* **Kiểm chứng luồng thu thập end-to-end:** Đã kiểm thử thành công hàm Lambda trên Console và xác minh toàn bộ luồng hoạt động đúng: Lambda gọi Cost Explorer API → ghi dữ liệu vào S3 → gửi sự kiện vào SQS. CloudWatch Logs ghi nhận đầy đủ, xác nhận thành phần Collector đã sẵn sàng để tích hợp với Lambda Analyzer ở tuần tiếp theo.