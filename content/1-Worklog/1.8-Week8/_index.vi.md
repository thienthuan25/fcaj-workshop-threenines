---
title: "Worklog Tuần 8"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.8. </b> "
---

### Mục tiêu tuần 8:

* Nâng cấp logic phân tích của Lambda Analyzer: bổ sung phát hiện bất thường dựa trên trung bình lịch sử (spike detection), không chỉ so ngưỡng cố định.
* Phân loại mức độ cảnh báo theo 3 cấp: INFO / WARNING / CRITICAL.
* Hoàn thiện nội dung cảnh báo SNS (kèm mức độ, lý do, phần trăm tăng đột biến).
* Kiểm chứng cơ chế xử lý lỗi (Dead Letter Queue) đảm bảo hệ thống chịu lỗi (resilient).
* Kiểm thử end-to-end toàn hệ thống: chỉ kích hoạt từ Collector, để cả luồng tự động chạy đến cảnh báo.

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Học tập trực tiếp tại văn phòng <br> - Nâng cấp logic phát hiện bất thường: <br>&emsp; + Viết hàm đọc dữ liệu chi phí các ngày lịch sử từ S3 và tính chi phí trung bình. <br>&emsp; + Bổ sung logic phát hiện tăng đột biến (chi phí > trung bình × hệ số). <br>&emsp; + Bổ sung 2 biến cấu hình `SPIKE_MULTIPLIER` và `HISTORY_DAYS`. | 29/06/2026 | 29/06/2026 | - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| 3 | - Phân loại mức độ cảnh báo & hoàn thiện nội dung SNS: <br>&emsp; + Xây dựng logic phân loại INFO / WARNING / CRITICAL theo ngưỡng và mức độ đột biến. <br>&emsp; + Cập nhật nội dung email cảnh báo: thêm mức độ, lý do cảnh báo, phần trăm tăng và trung bình lịch sử. <br>&emsp; + Chuẩn hóa định dạng hiển thị số tiền ($X.XX). | 30/06/2026 | 30/06/2026 |  |
| 4 | - Cập nhật Terraform, kiểm thử 3 mức & xử lý lỗi (DLQ): <br>&emsp; + Bổ sung biến `spike_multiplier`, `history_days` và triển khai code Analyzer nâng cấp. <br>&emsp; + Viết script sinh dữ liệu mô phỏng, kiểm thử 3 kịch bản INFO / WARNING / CRITICAL. <br>&emsp; + Kiểm thử DLQ: gửi message lỗi, xác minh message tự chuyển vào Dead Letter Queue. | 01/07/2026 | 01/07/2026 | - Amazon SQS Dead-Letter Queues: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html <br> - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function |
| 5 | - Kiểm thử end-to-end toàn hệ thống: <br>&emsp; + Chuẩn bị dữ liệu chi phí mô phỏng (lịch sử + ngày test) trong S3 cho các mức WARNING và CRITICAL. <br>&emsp; + Chỉ kích hoạt từ Lambda Collector, để hệ thống tự động chạy qua SQS → Analyzer mà không can thiệp thủ công. <br>&emsp; + Theo dõi cả chuỗi tự chạy: Collector → S3 → SQS → Analyzer → SNS. | 02/07/2026 | 02/07/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Using Lambda with SQS: <br> https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html |
| 6 | - Xác minh kết quả & tinh chỉnh: <br>&emsp; + Xác nhận email cảnh báo WARNING và CRITICAL nhận đúng, định dạng số tiền gọn ($X.XX). <br>&emsp; + Kiểm tra CloudWatch Logs xác nhận phân loại đúng mức. <br>&emsp; + Tinh chỉnh ngưỡng về giá trị thực tế và dọn dẹp dữ liệu test. | 03/07/2026 | 03/07/2026 | |

### Kết quả đạt được tuần 8:

* **Nâng cấp logic phát hiện bất thường thông minh:** Đã hoàn thiện Analyzer với hai tiêu chí phát hiện: (1) so sánh với ngưỡng ngân sách cố định, và (2) phát hiện tăng đột biến dựa trên chi phí trung bình của các ngày lịch sử đọc từ S3. Đây là bước tiến quan trọng, giúp hệ thống phát hiện được cả những trường hợp chi phí tăng bất thường dù chưa vượt ngưỡng tuyệt đối — tương tự cách AWS Cost Anomaly Detection hoạt động, nhưng do tự xây dựng.

* **Phân loại mức độ cảnh báo đa cấp:** Đã triển khai cơ chế phân loại cảnh báo theo 3 mức INFO / WARNING / CRITICAL. Nội dung email cảnh báo được hoàn thiện với đầy đủ mức độ, lý do cụ thể, phần trăm tăng đột biến và chi phí trung bình lịch sử, đồng thời chuẩn hóa định dạng hiển thị số tiền cho gọn gàng, dễ đọc.

* **Kiểm thử đầy đủ 3 trường hợp cảnh báo:** Đã xây dựng dữ liệu chi phí mô phỏng và kiểm thử thành công cả 3 kịch bản: INFO (chi phí bình thường, không cảnh báo), WARNING (vượt ngưỡng ngân sách) và CRITICAL (tăng đột biến so với trung bình lịch sử). Kết quả phân loại chính xác trên CloudWatch Logs, email cảnh báo được gửi đúng cho các mức WARNING và CRITICAL.

* **Xác minh cơ chế chịu lỗi (DLQ):** Đã kiểm thử thành công đường xử lý lỗi bằng cách gửi message lỗi (trỏ tới file không tồn tại). Message được retry theo cấu hình và tự động chuyển vào Dead Letter Queue sau khi vượt số lần thử tối đa — đảm bảo hệ thống không mất dữ liệu và không lặp vô hạn khi gặp sự cố.

* **Kiểm thử end-to-end toàn hệ thống:** Đã kiểm chứng thành công toàn bộ luồng hoạt động tự động: chỉ cần kích hoạt từ Lambda Collector, hệ thống tự động chạy qua các thành phần S3 → SQS → Analyzer → SNS mà không cần can thiệp thủ công. Kết quả xác nhận các thành phần tích hợp chính xác với nhau, hệ thống phát hiện đúng mức WARNING và CRITICAL, và gửi email cảnh báo hoàn chỉnh — chứng minh CloudCost Insight vận hành ổn định như một hệ thống hoàn chỉnh, tự động end-to-end.