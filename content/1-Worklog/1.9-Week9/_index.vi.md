---
title: "Worklog Tuần 9"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.9. </b> "
---

### Mục tiêu tuần 9:

* Bổ sung CloudWatch Alarm giám sát sự cố hệ thống: cảnh báo khi Lambda gặp lỗi và khi có message rơi vào DLQ.
* Kiểm thử thành công cơ chế Alarm → SNS → Email.
* Cập nhật sơ đồ kiến trúc: thay hướng Athena + QuickSight bằng hướng web dashboard tự xây (Lambda-API, API Gateway, CloudFront + S3 Web Hosting).
* Triển khai backend cho dashboard: viết Lambda-API, tạo API Gateway và kiểm thử API thành công.

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Bổ sung CloudWatch Alarm cảnh báo lỗi Lambda: <br>&emsp; + Cấu hình CloudWatch Alarm giám sát metric `Errors` của Lambda Collector và Analyzer. <br>&emsp; + Gắn action gửi thông báo qua SNS khi Alarm kích hoạt. <br>&emsp; + Triển khai bằng Terraform (`aws_cloudwatch_metric_alarm`). | 06/07/2026 | 06/07/2026 | - Terraform aws_cloudwatch_metric_alarm: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm <br> - Using CloudWatch Alarms: <br> https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html |
| 3 | - Bổ sung Alarm cho DLQ & kiểm thử Alarm: <br>&emsp; + Cấu hình Alarm giám sát metric `ApproximateNumberOfMessagesVisible` của Dead Letter Queue. <br>&emsp; + Gửi message lỗi để kích hoạt Alarm, kiểm thử thành công cơ chế Alarm → SNS → Email. <br>&emsp; + Xác nhận nhận được email cảnh báo sự cố với đầy đủ thông tin. | 07/07/2026 | 07/07/2026 | - Amazon SQS CloudWatch Metrics: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-monitoring-using-cloudwatch.html |
| 4 | - Cập nhật sơ đồ kiến trúc (chuyển hướng dashboard): <br>&emsp; + Loại bỏ Athena + QuickSight khỏi sơ đồ. <br>&emsp; + Bổ sung hướng web dashboard tự xây: Lambda-API, API Gateway, CloudFront, S3 (Web Hosting). <br>&emsp; + Vẽ lại luồng: User → CloudFront/S3 (tải giao diện) và User → API Gateway → Lambda-API → S3 (lấy dữ liệu). | 08/07/2026 | 08/07/2026 | - AWS Architecture Icons & công cụ vẽ sơ đồ (draw.io). |
| 5 | - Viết Lambda-API (backend cung cấp dữ liệu): <br>&emsp; + Viết hàm Lambda-API (Python) đọc và tổng hợp dữ liệu chi phí từ S3 (tổng chi phí, theo ngày kèm trạng thái, top dịch vụ). <br>&emsp; + Trả về JSON kèm CORS header để web frontend gọi được. <br>&emsp; + Áp dụng IAM Role riêng theo Least Privilege (chỉ đọc S3 + ghi log). | 09/07/2026 | 09/07/2026 | - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html <br> - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| 6 | - Tạo API Gateway & kiểm thử API: <br>&emsp; + Tạo HTTP API Gateway với route `GET /costs`, bật CORS. <br>&emsp; + Cấp quyền cho API Gateway gọi Lambda (`aws_lambda_permission`). <br>&emsp; + Kiểm thử API thành công: gọi endpoint trên trình duyệt và nhận về dữ liệu JSON đúng cấu trúc. | 10/07/2026 | 10/07/2026 | - Amazon API Gateway (HTTP API): <br> https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html <br> - Terraform aws_apigatewayv2_api: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api |

### Kết quả đạt được tuần 9:

* **Bổ sung giám sát sự cố bằng CloudWatch Alarm:** Đã cấu hình các Alarm giám sát sức khỏe hệ thống. Cảnh báo khi Lambda Collector/Analyzer gặp lỗi (metric `Errors`) và khi có message rơi vào Dead Letter Queue. Các Alarm gửi thông báo qua SNS, giúp người vận hành được báo ngay khi hệ thống gặp sự cố, đảm bảo hệ thống giám sát luôn hoạt động tin cậy.

* **Kiểm thử thành công cơ chế cảnh báo sự cố:** Đã kiểm thử thành công luồng Alarm → SNS → Email bằng cách gửi message lỗi để kích hoạt Alarm. Xác nhận nhận được email cảnh báo với đầy đủ thông tin (tên Alarm, lý do, metric, thời điểm). Đồng thời rút ra đặc điểm quan trọng: CloudWatch Alarm chỉ gửi thông báo tại thời điểm **chuyển trạng thái** (OK → ALARM), không gửi lặp khi đã ở trạng thái ALARM.

* **Cập nhật sơ đồ kiến trúc theo hướng web dashboard tự xây:** Đã loại bỏ hướng Athena + QuickSight (dịch vụ managed có phí) và chuyển sang hướng **tự xây web dashboard**: Lambda-API + API Gateway (backend cung cấp dữ liệu) và CloudFront + S3 Web Hosting (frontend). Sơ đồ thể hiện rõ 2 luồng riêng: tải giao diện web và lấy dữ liệu qua API, định hướng biến CloudCost Insight thành một product hoàn chỉnh do mình làm chủ.

* **Triển khai backend cung cấp dữ liệu (Lambda-API):** Đã phát triển thành công hàm Lambda-API đọc và tổng hợp dữ liệu chi phí từ S3 (tổng chi phí, chi phí theo ngày kèm trạng thái, top dịch vụ tốn kém nhất), trả về JSON kèm CORS header để frontend gọi được. Hàm áp dụng IAM Role riêng theo nguyên tắc Least Privilege, chỉ được cấp quyền đọc S3 và ghi log.

* **Tạo API Gateway & kiểm thử thành công:** Đã tạo HTTP API Gateway với route `GET /costs` (bật CORS), cấp quyền cho API Gateway gọi Lambda. Kiểm thử API thành công: gọi endpoint trực tiếp trên trình duyệt và nhận về dữ liệu JSON đúng cấu trúc, xác nhận tầng backend của web dashboard đã hoạt động, sẵn sàng cho việc xây dựng giao diện frontend ở tuần tiếp theo.