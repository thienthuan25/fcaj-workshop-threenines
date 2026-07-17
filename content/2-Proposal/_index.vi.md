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
CloudCost Insight được thiết kế nhằm giúp cá nhân, đội nhóm hoặc startup sử dụng AWS chủ động **giám sát, phân tích và cảnh báo chi phí** dịch vụ đám mây mà không cần thao tác thủ công. Nền tảng tự động thu thập dữ liệu chi phí định kỳ từ AWS Cost Explorer, lưu trữ và phân tích để phát hiện bất thường (chi phí tăng đột biến, vượt ngưỡng ngân sách), sau đó gửi cảnh báo qua Email và trực quan hóa trên một web dashboard tự xây. Hệ thống được xây dựng hoàn toàn theo kiến trúc AWS Serverless, không cần quản lý máy chủ, tự động co giãn, chi phí vận hành cực thấp (dưới 1 đến 2 USD/tháng), và triển khai bằng Terraform để có thể tái tạo, dọn dẹp dễ dàng.

### 2. Tuyên bố vấn đề
*Vấn đề hiện tại*
<br>Với mô hình tính phí theo mức dùng (pay-as-you-go) của AWS, chi phí rất dễ vượt tầm kiểm soát. Một cấu hình sai (quên tắt EC2, bật NAT Gateway, ghi log quá nhiều) có thể làm hóa đơn tăng vọt mà không ai phát hiện cho đến cuối kỳ. Billing Console chỉ hiển thị số liệu chứ không chủ động cảnh báo, và việc theo dõi thủ công nhiều dịch vụ, nhiều môi trường (dev/test/prod) tốn thời gian và dễ bỏ sót. Các công cụ FinOps bên thứ ba thường tốn kém và phức tạp so với nhu cầu quy mô nhỏ.

*Giải pháp*
<br>Nền tảng sử dụng **AWS Cost Explorer API** làm nguồn dữ liệu chi phí, **Amazon EventBridge** lập lịch chạy định kỳ, **AWS Lambda** (Collector) thu thập dữ liệu và **Amazon S3** lưu trữ. Một hàng đợi **Amazon SQS** được sử dụng làm vùng đệm (buffer) để lưu trữ tạm thời các sự kiện. Việc này giúp phân tách độc lập khâu thu thập và khâu phân tích, đảm bảo hai tiến trình hoạt động linh hoạt và không bị ách tắc lẫn nhau. Kế tiếp, **AWS Lambda** (Analyzer) sẽ lấy sự kiện từ hàng đợi để tiến hành phân tích, so sánh với ngưỡng ngân sách và phát hiện bất thường. Các sự kiện xử lý lỗi được đưa vào **SQS Dead Letter Queue (DLQ)**. Khi chi phí vượt ngưỡng, **Amazon SNS** gửi cảnh báo qua Email. **Amazon CloudWatch** giám sát log/metric và kích hoạt Alarm khi hệ thống gặp sự cố, trong khi **AWS IAM** và **AWS Secrets Manager** đảm bảo bảo mật. Đặc biệt, dữ liệu chi phí được cung cấp qua một **web dashboard tự xây** (dùng **AWS Lambda** làm API, **Amazon API Gateway** expose endpoint, giao diện web host trên **Amazon S3** và phân phối qua **Amazon CloudFront**) để trực quan hóa xu hướng chi phí. Người dùng có thể tùy chỉnh ngưỡng cảnh báo và xem báo cáo chi phí tập trung, thay vì kiểm tra thủ công từng dịch vụ.

*Lợi ích và hoàn vốn đầu tư (ROI)*
<br>Giải pháp giúp phát hiện sớm chi phí bất thường, tránh các hóa đơn "sốc" cuối tháng và tiết kiệm thời gian theo dõi thủ công. Hệ thống tạo nền tảng FinOps cơ bản có thể mở rộng thêm tính năng (dự báo chi phí, phân bổ chi phí theo tag/nhóm, đề xuất tối ưu). Chi phí vận hành hằng tháng ước tính dưới 1 đến 2 USD (chủ yếu nằm trong Free Tier), và không phát sinh chi phí phần cứng vì toàn bộ chạy trên AWS. Thời gian hoàn vốn gần như tức thì, chỉ cần hệ thống phát hiện được một lần chi phí bất thường là đã tiết kiệm nhiều hơn chi phí vận hành cả năm.

### 3. Kiến trúc giải pháp
Nền tảng áp dụng kiến trúc AWS Serverless, event-driven, có khả năng chịu lỗi (resilient). Dữ liệu chi phí được thu thập định kỳ từ Cost Explorer API bởi Lambda Collector, lưu vào S3, rồi đẩy sự kiện qua SQS để Lambda Analyzer xử lý và phát hiện bất thường. Cảnh báo được gửi qua SNS. Dữ liệu chi phí được trực quan hóa qua một web dashboard tự xây, trong đó Lambda-API cung cấp dữ liệu, API Gateway expose endpoint, giao diện web host trên S3 và phân phối qua CloudFront. Toàn bộ hạ tầng được triển khai bằng Terraform.


![CloudCost Insight Architecture](/fcaj-workshop-threenines/images/2-Proposal/CloudCostInsight.jpg)

*Dịch vụ AWS sử dụng*
- *Amazon EventBridge*: Lập lịch kích hoạt định kỳ (cron, ví dụ 1 lần/ngày).
- *AWS Lambda*: Xử lý dữ liệu gồm Collector (thu thập chi phí), Analyzer (phát hiện bất thường) và API (cung cấp dữ liệu cho dashboard) (3 hàm).
- *AWS Cost Explorer API*: Nguồn dữ liệu chi phí chính thức của AWS.
- *Amazon S3*: Lưu trữ dữ liệu chi phí (phân vùng theo ngày/tháng) và host giao diện web tĩnh (2 bucket).
- *Amazon SQS*: Hàng đợi đệm sự kiện và Dead Letter Queue (DLQ) cho xử lý lỗi.
- *Amazon SNS*: Gửi cảnh báo qua Email khi vượt ngưỡng hoặc khi hệ thống gặp sự cố.
- *Amazon CloudWatch*: Logs, Metrics và Alarm giám sát toàn hệ thống (lỗi Lambda, message vào DLQ).
- *Amazon API Gateway*: Expose Lambda-API thành endpoint HTTP để web dashboard gọi lấy dữ liệu.
- *Amazon CloudFront*: Phân phối giao diện web (CDN) với HTTPS.
- *AWS IAM*: Quản lý quyền theo nguyên tắc least privilege cho từng Lambda.
- *AWS Secrets Manager*: Lưu trữ an toàn các thông tin nhạy cảm (ví dụ Slack webhook).

*Thiết kế thành phần*
- *Lập lịch*: EventBridge kích hoạt Lambda Collector theo chu kỳ định trước.
- *Thu thập dữ liệu*: Lambda Collector gọi Cost Explorer API để lấy dữ liệu chi phí.
- *Lưu trữ dữ liệu*: Dữ liệu chi phí thô được lưu trong S3, phân vùng theo ngày/tháng.
- *Đệm sự kiện*: Collector đẩy sự kiện vào SQS Queue để tách rời khâu thu thập và phân tích.
- *Xử lý và phát hiện*: Lambda Analyzer đọc dữ liệu từ S3, tiêu thụ sự kiện từ SQS, so ngưỡng ngân sách và phát hiện tăng đột biến so với trung bình lịch sử. Sự kiện lỗi được đẩy vào DLQ.
- *Cảnh báo*: SNS gửi Email tới người dùng khi phát hiện chi phí vượt ngưỡng (phân loại INFO, WARNING, CRITICAL).
- *Giám sát*: CloudWatch thu thập log/metric của các Lambda và kích hoạt Alarm (gửi SNS) khi Lambda lỗi hoặc có message vào DLQ.
- *Trực quan hóa*: Web dashboard gọi API Gateway tới Lambda-API để đọc dữ liệu S3, dùng biểu đồ hiển thị xu hướng chi phí, ngưỡng và ngày bất thường. Giao diện host trên S3 và phân phối qua CloudFront.
- *Bảo mật*: IAM Role least privilege riêng cho từng Lambda. Secrets Manager lưu secret. S3 chặn truy cập public (dùng Origin Access Control cho web bucket).

### 4. Triển khai kỹ thuật
*Các giai đoạn triển khai*
<br>Dự án gồm 3 phần là hạ tầng nền, logic xử lý, và web dashboard, trải qua các giai đoạn sau:
1. *Nghiên cứu và vẽ kiến trúc*: Nghiên cứu Cost Explorer API, mô hình serverless và thiết kế kiến trúc AWS.
2. *Dựng hạ tầng nền bằng Terraform*: Tạo S3, IAM Role, SNS, SQS + DLQ, EventBridge (quản lý remote state trên HCP Terraform).
3. *Phát triển Lambda*: Viết Lambda Collector (tích hợp Cost Explorer API) và Lambda Analyzer (logic phát hiện bất thường và cảnh báo, phân loại 3 mức).
4. *Giám sát và xử lý lỗi*: Bổ sung CloudWatch Alarm (lỗi Lambda, DLQ) và kiểm chứng cơ chế Dead Letter Queue.
5. *Web dashboard*: Viết Lambda-API và API Gateway (backend), xây web frontend (HTML/CSS/JS + Chart.js) và host lên S3 + CloudFront.
6. *Kiểm thử end-to-end, viết báo cáo song ngữ và clean-up*.

*Yêu cầu kỹ thuật*
- *Hạ tầng (IaC)*: Kiến thức thực tế về Terraform để định nghĩa toàn bộ tài nguyên AWS. Quản lý remote state trên HCP Terraform để hỗ trợ làm việc nhóm. Toàn bộ hạ tầng tái tạo được bằng một lệnh và dọn dẹp sạch bằng `terraform destroy`.
- *Logic xử lý*: Lambda viết bằng Python (boto3), gọi Cost Explorer API (`ce:GetCostAndUsage`), xử lý và ghi dữ liệu vào S3, publish sự kiện SQS/SNS. Logic phát hiện bất thường dựa trên so sánh với ngưỡng ngân sách và trung bình chi phí lịch sử.
- *Web dashboard*: Lambda-API (Python) đọc dữ liệu S3 và trả JSON kèm CORS. API Gateway (HTTP API) expose endpoint. Frontend dùng Chart.js gọi API và vẽ biểu đồ, host tĩnh trên S3 + CloudFront.
- *Bảo mật*: IAM Role riêng cho từng Lambda theo least privilege. Không hard-code access key. S3 bật Block Public Access. Web bucket bảo mật bằng Origin Access Control (chỉ CloudFront đọc được).

### 5. Lộ trình và Mốc triển khai
- *Thực tập (Tháng 1 đến 3)*:
    - *Tháng 1*: Học về AWS và thiết kế kiến trúc.
    - *Tháng 2*: Xây dựng hệ thống (hạ tầng và Lambda) bằng Terraform.
    - *Tháng 3*: Bổ sung giám sát/cảnh báo, xây dựng web dashboard, kiểm thử end-to-end và đưa vào sử dụng.
- *Sau triển khai*: Mở rộng thêm tính năng (dự báo chi phí, phân bổ theo tag, gắn tên miền riêng cho dashboard).

### 6. Ước tính ngân sách
Có thể xem chi phí trên [AWS Pricing Calculator](https://calculator.aws/#/estimate)

*Chi phí hạ tầng*
- AWS Lambda: 0,00 USD/tháng (trong Free Tier, vài chục request/ngày, 3 hàm).
- Amazon S3: khoảng 0,05 USD/tháng (dung lượng nhỏ gồm dữ liệu chi phí JSON và web tĩnh).
- Amazon SQS: 0,00 USD/tháng (trong Free Tier, 1 triệu request/tháng).
- Amazon SNS: 0,00 USD/tháng (trong Free Tier, 1.000 email/tháng).
- Amazon EventBridge: 0,00 USD/tháng (trong Free Tier).
- Amazon API Gateway: 0,00 USD/tháng (trong Free Tier, 1 triệu request/tháng).
- Amazon CloudFront: khoảng 0,00 đến 0,10 USD/tháng (lưu lượng nhỏ, trong Free Tier).
- AWS Cost Explorer API: khoảng 0,30 USD/tháng (khoảng 0,01 USD/request, khoảng 1 request/ngày).
- Amazon CloudWatch: khoảng 0,10 USD/tháng (logs và alarm cơ bản).

*Tổng*: khoảng 0,5 đến 1 USD/tháng, khoảng 6 đến 12 USD/12 tháng.
- *Phần cứng*: 0 USD (toàn bộ chạy trên AWS, không cần thiết bị vật lý).

### 7. Đánh giá rủi ro
*Ma trận rủi ro*
- Gọi Cost Explorer API quá nhiều dẫn tới phát sinh chi phí: Ảnh hưởng trung bình, xác suất trung bình.
- Cấu hình IAM sai (thiếu hoặc thừa quyền): Ảnh hưởng cao, xác suất thấp.
- Cảnh báo sai hoặc spam do đặt ngưỡng chưa hợp lý: Ảnh hưởng thấp, xác suất trung bình.
- Quên clean-up dẫn tới phát sinh chi phí ngoài ý muốn: Ảnh hưởng trung bình, xác suất thấp.

*Chiến lược giảm thiểu*
- Chi phí API: Giới hạn tần suất gọi (1 lần/ngày), cache dữ liệu, đặt CloudWatch Alarm cho chi phí.
- IAM: Áp dụng least privilege, kiểm thử kỹ policy trước khi triển khai.
- Cảnh báo: Tinh chỉnh ngưỡng theo dữ liệu lịch sử, thêm logic chống trùng lặp.
- Clean-up: Dùng `terraform destroy` và checklist dọn dẹp cuối dự án.

*Kế hoạch dự phòng*
- Quay lại kiểm tra chi phí thủ công qua Billing Console nếu hệ thống gặp sự cố.
- Sử dụng Terraform (IaC) để khôi phục nhanh toàn bộ cấu hình hạ tầng.

### 8. Kết quả kỳ vọng
*Cải tiến kỹ thuật*: Giám sát và cảnh báo chi phí tự động, thời gian gần thực, thay thế việc kiểm tra thủ công. Kiến trúc serverless, event-driven, có khả năng chịu lỗi và dễ mở rộng, kèm web dashboard tự xây trực quan hóa dữ liệu.
<br>*Giá trị dài hạn*: Một product FinOps hoàn chỉnh (MVP) có thể tái sử dụng và mở rộng cho các dự án tương lai (dự báo chi phí, phân bổ chi phí theo phòng ban/dự án, đề xuất tối ưu tài nguyên, gắn tên miền riêng cho dashboard).