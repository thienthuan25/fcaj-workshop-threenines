---
title: "Worklog Tuần 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.5. </b> "
---

### Mục tiêu tuần 5:

* Thiết lập nền tảng hạ tầng cho dự án CloudCost Insight bằng Infrastructure as Code (Terraform).
* Cấu hình quản lý remote state trên HCP Terraform để phục vụ làm việc nhóm và bảo toàn trạng thái hạ tầng.
* Triển khai các thành phần hạ tầng nền: S3, IAM, SNS, SQS (kèm DLQ) và EventBridge, đảm bảo tuân thủ nguyên tắc bảo mật (least privilege, chặn truy cập public).
* Triển khai hạ tầng thực tế lên AWS và kiểm chứng (verify) toàn bộ tài nguyên trên Console.

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Thiết lập nền tảng Terraform & HCP: <br>&emsp; + Khởi tạo cấu trúc thư mục `terraform/`, viết file `versions.tf` (cấu hình provider AWS). <br>&emsp; + Cấu hình HCP Terraform (khối `cloud {}`) để quản lý remote state cho nhóm. <br>&emsp; + Định nghĩa các biến đầu vào trong `variables.tf` (region, project_name, alert_email, ngưỡng chi phí). | 08/06/2026 | 08/06/2026 | - Terraform AWS Provider: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs <br> - HCP Terraform Docs: <br> https://developer.hashicorp.com/terraform/cloud-docs |
| 3 | - Triển khai tầng lưu trữ & bảo mật (S3 + IAM): <br>&emsp; + Viết `s3.tf` tạo bucket lưu dữ liệu chi phí, bật Block Public Access, mã hóa SSE-S3, versioning và lifecycle tối ưu chi phí. <br>&emsp; + Viết `iam.tf` tạo IAM Role cho Lambda theo nguyên tắc Least Privilege. | 09/06/2026 | 09/06/2026 | - Amazon S3 User Guide: <br> https://docs.aws.amazon.com/AmazonS3/latest/userguide/ <br> - IAM Best Practices: <br> https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| 4 | - Triển khai tầng thông báo & hàng đợi (SNS + SQS): <br>&emsp; + Viết `sns.tf` tạo SNS Topic cảnh báo và subscription email. <br>&emsp; + Viết `sqs.tf` tạo hàng đợi chính và Dead Letter Queue (DLQ) với redrive policy để xử lý lỗi. | 10/06/2026 | 10/06/2026 | - Amazon SNS Developer Guide: <br> https://docs.aws.amazon.com/sns/latest/dg/ <br> - Amazon SQS Developer Guide: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/ |
| 5 | - Triển khai bộ lập lịch & khởi chạy hạ tầng: <br>&emsp; + Viết `eventbridge.tf` tạo rule lập lịch chạy định kỳ (rate 1 ngày). <br>&emsp; + Viết `outputs.tf` xuất các giá trị quan trọng (ARN, tên tài nguyên). <br>&emsp; + Chạy `terraform init`, `plan`, `apply` để triển khai hạ tầng lên AWS. | 11/06/2026 | 11/06/2026 | - Amazon EventBridge User Guide: <br> https://docs.aws.amazon.com/eventbridge/latest/userguide/ |
| 6 | - Kiểm chứng (verify) hạ tầng trên AWS Console: <br>&emsp; + Kiểm tra S3 (block public, mã hóa, versioning), IAM (least privilege), SNS (xác nhận subscription email), SQS (redrive policy tới DLQ), EventBridge (rule & lịch chạy). <br>&emsp; + Chụp screenshot các tài nguyên phục vụ báo cáo. | 12/06/2026 | 12/06/2026 | - AWS Management Console. |

### Kết quả đạt được tuần 5:

* **Thiết lập thành công nền tảng Infrastructure as Code:** Đã xây dựng cấu trúc dự án Terraform hoàn chỉnh và cấu hình HCP Terraform để quản lý remote state. Việc dùng remote state giúp trạng thái hạ tầng được lưu tập trung, hỗ trợ khóa trạng thái (state locking) — nền tảng quan trọng cho việc phối hợp và mở rộng dự án về sau.

* **Triển khai đầy đủ hạ tầng nền theo chuẩn bảo mật:** Hoàn thành việc định nghĩa và triển khai các thành phần cốt lõi: S3 (lưu trữ dữ liệu chi phí), IAM (phân quyền), SNS (cảnh báo), SQS + DLQ (đệm sự kiện và xử lý lỗi), EventBridge (lập lịch). Toàn bộ tuân thủ best practice bảo mật của AWS: bucket S3 chặn truy cập public và bật mã hóa, IAM Role được cấp quyền theo nguyên tắc Least Privilege, không hard-code thông tin nhạy cảm.

* **Áp dụng cơ chế xử lý lỗi (resilience):** Cấu hình Dead Letter Queue (DLQ) kèm redrive policy cho hàng đợi SQS, giúp hệ thống không mất dữ liệu khi có sự kiện xử lý thất bại — thể hiện tư duy thiết kế hệ thống có khả năng chịu lỗi.

* **Triển khai và kiểm chứng thực tế:** Đã chạy `terraform apply` thành công, đưa toàn bộ hạ tầng lên AWS. Tiến hành kiểm tra (verify) từng tài nguyên trên AWS Console để xác nhận cấu hình đúng như thiết kế, đồng thời xác nhận subscription email của SNS để sẵn sàng nhận cảnh báo. Hạ tầng nền đã sẵn sàng cho giai đoạn phát triển các hàm Lambda ở các tuần tiếp theo.