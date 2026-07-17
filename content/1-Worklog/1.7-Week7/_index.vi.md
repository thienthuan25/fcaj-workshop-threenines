---
title: "Worklog Tuần 7"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.7. </b> "
---

### Mục tiêu tuần 7:

* Phát triển hàm Lambda Analyzer — thành phần phân tích và cảnh báo chi phí của hệ thống CloudCost Insight.
* Đọc dữ liệu chi phí từ S3 và xây dựng logic so sánh với ngưỡng ngân sách để phát hiện chi phí vượt mức.
* Tích hợp Amazon SNS để gửi cảnh báo qua email khi phát hiện chi phí vượt ngưỡng.
* Kết nối SQS với Lambda Analyzer (Event Source Mapping) để xử lý sự kiện tự động, áp dụng IAM Role riêng theo Least Privilege.
* Kiểm chứng luồng phân tích – cảnh báo end-to-end (SQS → Analyzer → S3 → SNS → Email).

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Thiết kế logic phân tích & viết code Analyzer: <br>&emsp; + Thiết kế logic đọc dữ liệu chi phí từ S3, tính tổng và lấy top dịch vụ tốn chi phí nhất. <br>&emsp; + Xây dựng logic so sánh tổng chi phí với ngưỡng ngân sách (threshold). <br>&emsp; + Viết code Lambda Analyzer bằng Python + boto3. | 22/06/2026 | 22/06/2026 | - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html <br> - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| 3 | - Tích hợp cảnh báo SNS: <br>&emsp; + Viết hàm gửi cảnh báo qua SNS khi chi phí vượt ngưỡng. <br>&emsp; + Định dạng nội dung cảnh báo (tổng chi phí, ngưỡng, top dịch vụ tốn nhất). <br>&emsp; + Truyền cấu hình (BUCKET_NAME, SNS_TOPIC_ARN, COST_THRESHOLD_USD) qua biến môi trường. | 23/06/2026 | 23/06/2026 | - Boto3 SNS Publish: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html <br> - Amazon SNS Developer Guide: <br> https://docs.aws.amazon.com/sns/latest/dg/ |
| 4 | - Viết Terraform triển khai Analyzer & IAM Role riêng: <br>&emsp; + Viết `lambda_analyzer.tf`: đóng gói code, tạo hàm Lambda, log group với retention. <br>&emsp; + Tạo IAM Role riêng cho Analyzer theo Least Privilege (chỉ đọc S3, nhận SQS, publish SNS). | 24/06/2026 | 24/06/2026 | - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function <br> - IAM Best Practices: <br> https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| 5 | - Kết nối SQS → Lambda (Event Source Mapping): <br>&emsp; + Viết `aws_lambda_event_source_mapping` để SQS tự động kích hoạt Analyzer. <br>&emsp; + Cấu hình batch size và liên kết hàng đợi chính với hàm Analyzer. <br>&emsp; + Chạy `terraform apply` triển khai Analyzer lên AWS. | 25/06/2026 | 25/06/2026 | - Terraform aws_lambda_event_source_mapping: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping <br> - Using Lambda with SQS: <br> https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html |
| 6 | - Kiểm thử & xác minh luồng cảnh báo: <br>&emsp; + Đặt tạm ngưỡng `threshold = -1` để kiểm thử logic vượt ngưỡng độc lập với độ trễ của Cost Explorer (chi phí thực tế đang ở mức \$0). <br>&emsp; + Chạy Collector tạo sự kiện, xác minh Analyzer phát hiện vượt ngưỡng qua CloudWatch Logs. <br>&emsp; + Xác nhận nhận được email cảnh báo từ SNS. | 26/06/2026 | 26/06/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Amazon CloudWatch Logs. |

### Kết quả đạt được tuần 7:

* **Hoàn thành thành phần phân tích & cảnh báo (Analyzer):** Đã phát triển thành công hàm Lambda Analyzer bằng Python và boto3, có khả năng đọc dữ liệu chi phí từ S3, tính tổng chi phí, xác định top dịch vụ tốn kém nhất và so sánh với ngưỡng ngân sách để phát hiện chi phí vượt mức.

* **Tích hợp cảnh báo tự động qua email:** Đã tích hợp Amazon SNS để gửi cảnh báo chi tiết qua email khi chi phí vượt ngưỡng. Nội dung cảnh báo bao gồm tổng chi phí, ngưỡng đã đặt và danh sách các dịch vụ tốn kém nhất, giúp người dùng nắm nhanh tình hình và xử lý kịp thời.

* **Kiến trúc tự động và tách rời (decoupling):** Đã cấu hình Event Source Mapping để SQS tự động kích hoạt Lambda Analyzer, hoàn thiện luồng xử lý bất đồng bộ giữa khâu thu thập (Collector) và phân tích (Analyzer). Kiến trúc này giúp hệ thống linh hoạt, dễ mở rộng và chịu tải tốt hơn.

* **Bảo mật theo nguyên tắc Least Privilege:** Đã tạo IAM Role riêng biệt cho Analyzer, tách bạch với Collector. Analyzer chỉ được cấp quyền tối thiểu cần thiết (đọc S3, nhận message từ SQS, publish SNS), tuân thủ chặt chẽ best practice bảo mật của AWS — một điểm cộng quan trọng về mặt thiết kế an toàn.

* **Kiểm chứng luồng cảnh báo end-to-end:** Đã kiểm thử thành công bằng phương pháp đặt tạm ngưỡng cảnh báo `threshold = -1`, giúp xác minh logic phát hiện vượt ngưỡng một cách độc lập với độ trễ 24h của Cost Explorer API (khi chi phí thực tế của tài khoản đang ở mức \$0). Kết quả: Analyzer phát hiện chính xác chi phí vượt ngưỡng, ghi log đầy đủ trên CloudWatch và gửi thành công email cảnh báo qua SNS — xác nhận toàn bộ luồng phân tích – cảnh báo hoạt động hoàn chỉnh.