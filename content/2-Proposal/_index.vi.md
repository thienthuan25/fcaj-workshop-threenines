---
title: "Bản đề xuất"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---


# CloudCost Insight
## Giải pháp AWS Serverless giám sát và cảnh báo chi phí đám mây thời gian gần thực

### 1. Tóm tắt điều hành
CloudCost Insight được thiết kế nhằm giúp cá nhân, đội nhóm hoặc startup sử dụng AWS chủ động **giám sát, phân tích và cảnh báo chi phí** dịch vụ đám mây mà không cần thao tác thủ công. Nền tảng tự động thu thập dữ liệu chi phí định kỳ từ AWS Cost Explorer, lưu trữ và phân tích để phát hiện bất thường (chi phí tăng đột biến, vượt ngưỡng ngân sách), sau đó gửi cảnh báo qua Email/Slack. Hệ thống xây dựng hoàn toàn theo kiến trúc AWS Serverless — không cần quản lý máy chủ, tự động co giãn, chi phí vận hành cực thấp (dưới 1–2 USD/tháng) — và triển khai bằng Terraform để có thể tái tạo, dọn dẹp dễ dàng.

### 2. Tuyên bố vấn đề
*Vấn đề hiện tại*
Với mô hình tính phí theo mức dùng (pay-as-you-go) của AWS, chi phí rất dễ vượt tầm kiểm soát: một cấu hình sai (quên tắt EC2, bật NAT Gateway, ghi log quá nhiều) có thể làm hóa đơn tăng vọt mà không ai phát hiện cho đến cuối kỳ. Billing Console chỉ hiển thị số liệu chứ không chủ động cảnh báo, và việc theo dõi thủ công nhiều dịch vụ, nhiều môi trường (dev/test/prod) tốn thời gian và dễ bỏ sót. Các công cụ FinOps bên thứ ba thường tốn kém và phức tạp so với nhu cầu quy mô nhỏ.

*Giải pháp*
Nền tảng sử dụng **AWS Cost Explorer API** làm nguồn dữ liệu chi phí, **Amazon EventBridge** lập lịch chạy định kỳ, **AWS Lambda** (Collector) thu thập dữ liệu và **Amazon S3** lưu trữ. Một hàng đợi **Amazon SQS** đệm sự kiện giúp giảm khớp nối, sau đó **AWS Lambda** (Analyzer) phân tích, so ngưỡng và phát hiện bất thường; các sự kiện xử lý lỗi được đưa vào **SQS Dead Letter Queue (DLQ)**. Khi chi phí vượt ngưỡng, **Amazon SNS** gửi cảnh báo qua Email/Slack. **Amazon CloudWatch** giám sát log/metric/alarm toàn hệ thống, **AWS IAM** và **AWS Secrets Manager** đảm bảo bảo mật, và **Amazon QuickSight** cung cấp dashboard trực quan hóa xu hướng chi phí. Người dùng có thể tùy chỉnh ngưỡng cảnh báo và xem báo cáo chi phí tập trung, thay vì kiểm tra thủ công từng dịch vụ.

*Lợi ích và hoàn vốn đầu tư (ROI)*
Giải pháp giúp phát hiện sớm chi phí bất thường, tránh các hóa đơn "sốc" cuối tháng và tiết kiệm thời gian theo dõi thủ công. Hệ thống tạo nền tảng FinOps cơ bản có thể mở rộng thêm tính năng (dự báo chi phí, phân bổ chi phí theo tag/nhóm, đề xuất tối ưu). Chi phí vận hành hằng tháng ước tính dưới 1–2 USD (chủ yếu nằm trong Free Tier), và không phát sinh chi phí phần cứng vì toàn bộ chạy trên AWS. Thời gian hoàn vốn gần như tức thì: chỉ cần hệ thống phát hiện được một lần chi phí bất thường là đã tiết kiệm nhiều hơn chi phí vận hành cả năm.

### 3. Kiến trúc giải pháp
Nền tảng áp dụng kiến trúc AWS Serverless, event-driven, có khả năng chịu lỗi (resilient). Dữ liệu chi phí được thu thập định kỳ từ Cost Explorer API bởi Lambda Collector, lưu vào S3, đẩy sự kiện qua SQS để Lambda Analyzer xử lý và phát hiện bất thường; cảnh báo được gửi qua SNS, dashboard hiển thị bằng QuickSight. Toàn bộ hạ tầng được triển khai bằng Terraform.


![CloudCost Insight Architecture](/images/CloudCostInsight-diagram.png)

*Dịch vụ AWS sử dụng*
- *Amazon EventBridge*: Lập lịch kích hoạt định kỳ (cron, ví dụ 1 lần/ngày).
- *AWS Lambda*: Xử lý dữ liệu — Collector (thu thập chi phí) và Analyzer (phát hiện bất thường) (2 hàm).
- *AWS Cost Explorer API*: Nguồn dữ liệu chi phí chính thức của AWS.
- *Amazon S3*: Lưu trữ dữ liệu chi phí (phân vùng theo ngày/tháng).
- *Amazon SQS*: Hàng đợi đệm sự kiện + Dead Letter Queue (DLQ) cho xử lý lỗi.
- *Amazon SNS*: Gửi cảnh báo qua Email/Slack khi vượt ngưỡng.
- *Amazon CloudWatch*: Logs, Metrics, Alarm giám sát toàn hệ thống.
- *AWS IAM*: Quản lý quyền theo nguyên tắc least privilege cho từng Lambda.
- *AWS Secrets Manager*: Lưu trữ an toàn các thông tin nhạy cảm (ví dụ Slack webhook).
- *Amazon QuickSight*: Dashboard trực quan hóa xu hướng chi phí.

*Thiết kế thành phần*
- *Lập lịch*: EventBridge kích hoạt Lambda Collector theo chu kỳ định trước.
- *Thu thập dữ liệu*: Lambda Collector gọi Cost Explorer API để lấy dữ liệu chi phí.
- *Lưu trữ dữ liệu*: Dữ liệu chi phí thô được lưu trong S3, phân vùng theo ngày/tháng.
- *Đệm sự kiện*: Collector đẩy sự kiện vào SQS Queue để tách rời khâu thu thập và phân tích.
- *Xử lý & phát hiện*: Lambda Analyzer đọc dữ liệu từ S3, tiêu thụ sự kiện từ SQS, so ngưỡng ngân sách và phát hiện bất thường; sự kiện lỗi được đẩy vào DLQ.
- *Cảnh báo*: SNS gửi Email/Slack tới người dùng khi phát hiện chi phí vượt ngưỡng.
- *Giám sát*: CloudWatch thu thập log/metric của cả hai Lambda và kích hoạt Alarm khi có lỗi.
- *Trực quan hóa*: QuickSight đọc dữ liệu từ S3 để hiển thị dashboard xu hướng chi phí.
- *Bảo mật*: IAM Role least privilege cho từng thành phần; Secrets Manager lưu secret; S3 chặn truy cập public.

### 4. Triển khai kỹ thuật
*Các giai đoạn triển khai*
Dự án gồm 2 phần — xây dựng hạ tầng nền và phát triển logic xử lý — trải qua 4 giai đoạn:
1. *Nghiên cứu và vẽ kiến trúc*: Nghiên cứu Cost Explorer API, mô hình serverless và thiết kế kiến trúc AWS (Tuần 1).
2. *Dựng hạ tầng nền bằng Terraform*: Tạo S3, IAM Role, SNS, SQS, EventBridge (Tuần 2).
3. *Phát triển Lambda*: Viết Lambda Collector (tích hợp Cost Explorer API) và Lambda Analyzer (logic phát hiện bất thường & cảnh báo) (Tuần 3–4).
4. *Dashboard, kiểm thử, triển khai*: Xây dashboard QuickSight, kiểm thử end-to-end, viết báo cáo song ngữ và clean-up (Tuần 5–6).

*Yêu cầu kỹ thuật*
- *Hạ tầng (IaC)*: Kiến thức thực tế về Terraform để định nghĩa toàn bộ tài nguyên AWS (S3, IAM, Lambda, SQS, SNS, EventBridge, CloudWatch). Toàn bộ hạ tầng phải tái tạo được bằng một lệnh và dọn dẹp sạch bằng `terraform destroy`.
- *Logic xử lý*: Lambda viết bằng Python (boto3), gọi Cost Explorer API (`ce:GetCostAndUsage`), xử lý và ghi dữ liệu vào S3, publish sự kiện SQS/SNS. Logic phát hiện bất thường dựa trên so sánh với ngưỡng ngân sách và xu hướng chi phí lịch sử.
- *Bảo mật*: IAM Role riêng cho từng Lambda theo least privilege; không hard-code access key; secret (Slack webhook) lưu trong Secrets Manager; S3 bật Block Public Access và mã hóa.

### 5. Lộ trình & Mốc triển khai
- *Thực tập (Tháng 1-3)*: 
    - *Tháng 1*: Học về AWS và thiết kế kiến trúc.
    - *Tháng 2*: Xây dựng hệ thống bằng Terraform.
    - *Tháng 3*: Triển khai, kiểm thử và đưa vào sử dụng.
- *Sau triển khai*: Mở rộng thêm tính năng (dự báo chi phí, phân bố theo tag).

### 6. Ước tính ngân sách
Có thể xem chi phí trên [AWS Pricing Calculator](https://calculator.aws/#/estimate)

*Chi phí hạ tầng*
- AWS Lambda: 0,00 USD/tháng (trong Free Tier — vài chục request/ngày).
- Amazon S3: ~0,05 USD/tháng (dung lượng nhỏ, dữ liệu chi phí dạng JSON/CSV).
- Amazon SQS: 0,00 USD/tháng (trong Free Tier — 1 triệu request/tháng).
- Amazon SNS: 0,00 USD/tháng (trong Free Tier — 1.000 email/tháng).
- Amazon EventBridge: 0,00 USD/tháng (trong Free Tier).
- AWS Cost Explorer API: ~0,30 USD/tháng (~0,01 USD/request, ~1 request/ngày).
- Amazon CloudWatch: ~0,10 USD/tháng (logs & alarm cơ bản).
- Amazon QuickSight: chi phí theo gói tác giả (có thể dùng Grafana để tiết kiệm).

*Tổng*: khoảng 0,5–2 USD/tháng, ~6–24 USD/12 tháng (chưa gồm QuickSight)
- *Phần cứng*: 0 USD (toàn bộ chạy trên AWS, không cần thiết bị vật lý).

### 7. Đánh giá rủi ro
*Ma trận rủi ro*
- Gọi Cost Explorer API quá nhiều → phát sinh chi phí: Ảnh hưởng trung bình, xác suất trung bình.
- Cấu hình IAM sai (thiếu/thừa quyền): Ảnh hưởng cao, xác suất thấp.
- Cảnh báo sai/spam do đặt ngưỡng chưa hợp lý: Ảnh hưởng thấp, xác suất trung bình.
- Quên clean-up → phát sinh chi phí ngoài ý muốn: Ảnh hưởng trung bình, xác suất thấp.

*Chiến lược giảm thiểu*
- Chi phí API: Giới hạn tần suất gọi (1 lần/ngày), cache dữ liệu, đặt CloudWatch Alarm cho chi phí.
- IAM: Áp dụng least privilege, kiểm thử kỹ policy trước khi triển khai.
- Cảnh báo: Tinh chỉnh ngưỡng theo dữ liệu lịch sử, thêm logic chống trùng lặp.
- Clean-up: Dùng `terraform destroy` và checklist dọn dẹp cuối dự án.

*Kế hoạch dự phòng*
- Quay lại kiểm tra chi phí thủ công qua Billing Console nếu hệ thống gặp sự cố.
- Sử dụng Terraform (IaC) để khôi phục nhanh toàn bộ cấu hình hạ tầng.

### 8. Kết quả kỳ vọng
*Cải tiến kỹ thuật*: Giám sát và cảnh báo chi phí tự động, thời gian gần thực, thay thế việc kiểm tra thủ công. Kiến trúc serverless, event-driven, có khả năng chịu lỗi và dễ mở rộng.
*Giá trị dài hạn*: Nền tảng FinOps cơ bản có thể tái sử dụng và mở rộng cho các dự án tương lai (dự báo chi phí, phân bổ chi phí theo phòng ban/dự án, đề xuất tối ưu tài nguyên).