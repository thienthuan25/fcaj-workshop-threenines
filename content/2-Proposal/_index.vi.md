---
title: "Bản đề xuất"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 2. </b> "
---


# CloudCost Insight
## Giải pháp AWS Serverless Giám Sát, Phân Tích và Cảnh Báo Chi Phí Đám Mây

### 1. Tóm tắt điều hành
CloudCost Insight là giải pháp hỗ trợ cá nhân, đội nhóm và startup chủ động giám sát, phân tích và cảnh báo chi phí AWS. Hệ thống tự động thu thập dữ liệu chi phí định kỳ từ AWS Cost Explorer, lưu trữ dữ liệu, phân tích các trường hợp vượt ngưỡng hoặc tăng đột biến, sau đó gửi cảnh báo qua email và trực quan hóa kết quả trên Web Dashboard.

Giải pháp được xây dựng theo kiến trúc AWS Serverless và event-driven, không cần quản lý máy chủ, có khả năng tự động co giãn và phù hợp với quy mô nhỏ. Toàn bộ hạ tầng được định nghĩa bằng Terraform, quản lý remote state trên HCP Terraform và triển khai tự động bằng GitHub Actions. Dashboard được bảo vệ bằng Amazon Cognito, JWT Authorizer và cấu hình CORS chỉ cho phép domain CloudFront của dự án truy cập API.

### 2. Tuyên bố vấn đề
*Vấn đề hiện tại*
<br>Với mô hình tính phí theo mức sử dụng của AWS, chi phí có thể tăng nhanh do cấu hình sai hoặc tài nguyên không được kiểm soát, chẳng hạn như quên tắt EC2, sử dụng NAT Gateway không cần thiết hoặc tạo quá nhiều CloudWatch Logs. Người dùng thường chỉ phát hiện vấn đề khi kiểm tra Billing Console hoặc nhận hóa đơn cuối tháng.

Việc theo dõi thủ công nhiều dịch vụ tốn thời gian và dễ bỏ sót. Trong khi đó, các nền tảng FinOps chuyên dụng có thể phức tạp hoặc không phù hợp với nhu cầu của cá nhân, nhóm nhỏ và môi trường học tập.

*Giải pháp*
<br>CloudCost Insight sử dụng AWS Cost Explorer API để lấy dữ liệu chi phí theo ngày và theo dịch vụ. Amazon EventBridge kích hoạt Lambda Collector định kỳ để thu thập dữ liệu, lưu vào Amazon S3 và gửi event vào Amazon SQS.

Lambda Analyzer nhận event từ SQS, đọc dữ liệu từ S3, so sánh chi phí với ngưỡng ngân sách và trung bình lịch sử để phát hiện bất thường. Các message lỗi được xử lý bằng cơ chế SQS partial batch failure, chỉ retry những message thất bại và chuyển chúng vào Dead Letter Queue (DLQ) nếu vượt quá số lần retry cho phép.

Khi phát hiện bất thường hoặc sự cố vận hành, hệ thống sử dụng Amazon SNS để gửi email cảnh báo. Amazon CloudWatch thu thập logs, metrics và kích hoạt alarm khi Lambda phát sinh lỗi hoặc DLQ có message.

Dữ liệu chi phí được cung cấp qua Web Dashboard. Lambda API đọc dữ liệu từ S3, Amazon API Gateway cung cấp HTTP API và giao diện web được host trên Amazon S3, phân phối qua Amazon CloudFront. Người dùng cần đăng nhập bằng Amazon Cognito để nhận JWT hợp lệ trước khi có thể truy cập dữ liệu chi phí.

*Lợi ích và hoàn vốn đầu tư (ROI)*
<br>Giải pháp giúp phát hiện sớm chi phí vượt ngưỡng hoặc tăng đột biến, giảm nguy cơ phát sinh hóa đơn ngoài dự kiến và tiết kiệm thời gian theo dõi thủ công. Hệ thống tạo nền tảng FinOps cơ bản có thể mở rộng thêm dự báo chi phí, phân bổ chi phí theo tag hoặc đề xuất tối ưu tài nguyên.

Với tần suất thu thập thấp và kiến trúc serverless, chi phí vận hành phù hợp cho môi trường workshop hoặc quy mô nhỏ. Chỉ cần phát hiện và ngăn chặn một sự cố chi phí đáng kể, lợi ích nhận được có thể lớn hơn chi phí vận hành hệ thống.

### 3. Kiến trúc giải pháp
Nền tảng áp dụng kiến trúc AWS Serverless, event-driven và có khả năng chịu lỗi. Lambda Collector thu thập dữ liệu định kỳ từ Cost Explorer, lưu dữ liệu vào S3 và gửi event vào SQS. Lambda Analyzer xử lý event, phân tích chi phí, gửi cảnh báo qua SNS và sử dụng DLQ cho các message không thể xử lý thành công.

Web Dashboard lấy dữ liệu qua API Gateway và Lambda API. Amazon Cognito bảo vệ Dashboard bằng cơ chế xác thực JWT; CORS chỉ cho phép domain CloudFront hợp lệ gọi API từ trình duyệt. Toàn bộ hạ tầng được triển khai bằng Terraform và tự động hóa bằng GitHub Actions.


![CloudCost Insight Architecture](/workshop-fcaj-intern/images/2-Proposal/diagram_architecture.png)

*Dịch vụ AWS sử dụng*
- *Amazon EventBridge*: Lập lịch kích hoạt Lambda Collector định kỳ.
- *AWS Lambda*: Bao gồm Collector, Analyzer và API cung cấp dữ liệu cho Dashboard.
- *AWS Cost Explorer API*: Nguồn dữ liệu chi phí và mức sử dụng AWS.
- *Amazon S3*: Lưu dữ liệu chi phí theo cấu trúc phân vùng ngày/tháng/năm và lưu trữ giao diện web tĩnh.
- *Amazon SQS*: Hàng đợi trung gian giữa Collector và Analyzer.
- *Amazon SQS Dead Letter Queue*: Lưu các message không xử lý thành công sau khi retry.
- *Amazon SNS*: Gửi email cảnh báo chi phí và cảnh báo sự cố.
- *Amazon CloudWatch*: Thu thập logs, metrics và tạo alarm giám sát Lambda hoặc DLQ.
- *Amazon API Gateway*: Cung cấp HTTP API cho Web Dashboard.
- *Amazon CloudFront*: Phân phối giao diện web qua HTTPS.
- *Amazon Cognito*: Quản lý người dùng, đăng nhập và cấp JWT cho Dashboard.
- *AWS IAM*: Cấp quyền theo nguyên tắc least privilege cho từng thành phần.
- *HCP Terraform*: Quản lý remote state và thực hiện Terraform remote run.
- *GitHub Actions*: Tự động kiểm tra mã nguồn và triển khai hạ tầng.

*Thiết kế thành phần*
- *Lập lịch*: EventBridge kích hoạt Lambda Collector theo chu kỳ định trước.
- *Thu thập dữ liệu*: Lambda Collector gọi Cost Explorer API để lấy chi phí theo ngày và theo dịch vụ.
- *Lưu trữ dữ liệu*: Dữ liệu chi phí được lưu trong S3 theo cấu trúc year/month/day.
- *Đệm sự kiện*: Collector gửi event vào SQS để tách rời quá trình thu thập và phân tích.
- *Xử lý và phát hiện*: Analyzer đọc dữ liệu từ S3, so sánh với ngưỡng ngân sách và mức trung bình lịch sử để xác định mức INFO, WARNING hoặc CRITICAL.
- *Xử lý lỗi*: Khi một message trong batch bị lỗi, Analyzer trả về batchItemFailures để SQS chỉ retry message lỗi. Message thất bại nhiều lần được chuyển vào DLQ.
- *Cảnh báo*: SNS gửi email khi chi phí vượt ngưỡng, tăng đột biến hoặc hệ thống phát sinh sự cố.
- *Giám sát*: CloudWatch theo dõi logs, lỗi Lambda và số message trong DLQ.
- *Trực quan hóa*: Dashboard hiển thị KPI, xu hướng chi phí, ngưỡng cảnh báo và các dịch vụ có chi phí cao nhất.
- *Bảo mật*: Cognito xác thực người dùng; API Gateway kiểm tra JWT; CORS chỉ cho phép domain CloudFront; S3 Block Public Access và CloudFront Origin Access Control bảo vệ web bucket.

### 4. Triển khai kỹ thuật
*Các giai đoạn triển khai*
<br>Dự án được triển khai theo các giai đoạn sau:
1. *Nghiên cứu và thiết kế kiến trúc*: Nghiên cứu AWS Cost Explorer API, mô hình serverless, event-driven và thiết kế kiến trúc hệ thống.
2. *Xây dựng hạ tầng bằng Terraform*: Tạo S3, IAM Role, SNS, SQS, DLQ, EventBridge, CloudWatch, API Gateway, CloudFront và Cognito.
3. *Phát triển Lambda*: Xây dựng Lambda Collector, Analyzer và API bằng Python cùng boto3.
4. *Bổ sung khả năng chịu lỗi*: Cấu hình SQS partial batch failure, DLQ, xử lý lỗi đọc dữ liệu S3 và CloudWatch Alarm.
5. *Xây dựng Web Dashboard*: Phát triển frontend HTML/CSS/JavaScript với Chart.js, tích hợp API Gateway, Cognito và CloudFront.
6. *Kiểm thử hệ thống*: Kiểm thử luồng thu thập dữ liệu, phát hiện bất thường, DLQ, partial batch failure, lỗi S3, CloudWatch Alarm, bảo mật Cognito/JWT, CORS và cache frontend.
7. *Tự động hóa CI/CD*: Cấu hình GitHub Actions kiểm tra Hugo Workshop, Python, Terraform và JavaScript; tự động Terraform Apply sau khi thay đổi được merge vào main.
8. *Dọn dẹp tài nguyên*: Thực hiện terraform destroy sau khi hoàn thành workshop để tránh phát sinh chi phí.

*Yêu cầu kỹ thuật*
- *Hạ tầng (IaC)*: Terraform định nghĩa toàn bộ tài nguyên AWS; remote state được quản lý trên HCP Terraform; hạ tầng có thể tái tạo bằng terraform apply và dọn dẹp bằng terraform destroy.
- *Logic xử lý*: Lambda Python sử dụng boto3 để gọi ce:GetCostAndUsage, lưu dữ liệu S3, gửi message SQS và gửi cảnh báo SNS.
- *Web Dashboard*: Lambda API đọc dữ liệu từ S3 và trả JSON; API Gateway cung cấp endpoint; frontend sử dụng Chart.js để trực quan hóa dữ liệu.
- *Bảo mật*: IAM least privilege, S3 Block Public Access, CloudFront Origin Access Control, Cognito User Pool, JWT Authorizer và CORS giới hạn domain.
- *Kiểm thử*: Unit test sử dụng pytest và mock AWS client; kiểm thử hệ thống thực hiện trên AWS Console, CloudWatch Logs, SQS, Cognito và Dashboard.
- *CI/CD*: GitHub Actions kiểm tra mã nguồn trước khi merge và triển khai Terraform thông qua HCP Terraform.

### 5. Lộ trình và Mốc triển khai
- *Thực tập (Tháng 1 đến 3)*:
    - *Tháng 1*: Học về AWS và thiết kế kiến trúc.
    - *Tháng 2*: Xây dựng hạ tầng, Lambda Collector, Analyzer, SQS, DLQ, SNS và CloudWatch.
    - *Tháng 3*: Phát triển Dashboard, bổ sung Cognito, kiểm thử hệ thống, xây dựng CI/CD và hoàn thiện workshop.
- *Sau triển khai*:  Mở rộng dự án với dự báo chi phí, phân bổ chi phí theo tag, đề xuất tối ưu tài nguyên hoặc gắn tên miền riêng cho Dashboard.

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
- Amazon Cognito: 0.00 USD/tháng (trong free 10.000 MAU/tháng)

*Tổng*: khoảng 0,5 đến 1 USD/tháng, khoảng 6 đến 12 USD/12 tháng.
- *Phần cứng*: 0 USD (toàn bộ chạy trên AWS, không cần thiết bị vật lý).

### 7. Đánh giá rủi ro
*Ma trận rủi ro*
- Gọi Cost Explorer API quá nhiều dẫn đến tăng chi phí: Ảnh hưởng trung bình, xác suất thấp.
- Cấu hình IAM hoặc Cognito không chính xác: Ảnh hưởng cao, xác suất thấp.
- Cảnh báo không phù hợp do ngưỡng hoặc dữ liệu lịch sử chưa đầy đủ: Ảnh hưởng trung bình, xác suất trung bình.
- Message xử lý lỗi bị retry nhiều lần: Ảnh hưởng trung bình, xác suất thấp.
- Quên dọn dẹp tài nguyên AWS: Ảnh hưởng trung bình, xác suất trung bình.
- Triển khai thay đổi Terraform lỗi lên production: Ảnh hưởng cao, xác suất thấp.

*Chiến lược giảm thiểu*
- Chi phí API: Giới hạn Collector chạy theo lịch định kỳ, không gọi Cost Explorer không cần thiết và theo dõi Billing Dashboard.
- Bảo mật: Áp dụng IAM least privilege, Cognito JWT Authorizer, CORS giới hạn CloudFront và không lưu token trực tiếp trong mã nguồn.
- Cảnh báo: Điều chỉnh ngưỡng ngân sách và số ngày lịch sử phù hợp với dữ liệu thực tế.
- Xử lý lỗi: Dùng partial batch failure, DLQ và CloudWatch Alarm để không bỏ sót message lỗi.
- Triển khai: Dùng Pull Request, CI, branch protection và GitHub Environment trước khi Terraform Apply.
- Clean-up: Kiểm tra terraform plan -destroy, sau đó chạy terraform destroy khi không còn sử dụng.

*Kế hoạch dự phòng*
- Kiểm tra chi phí thủ công trên AWS Billing Console hoặc Cost Explorer khi hệ thống gặp sự cố.
- Kiểm tra CloudWatch Logs, SQS và DLQ để xác định message lỗi.
- Sử dụng Terraform để tái tạo toàn bộ hạ tầng khi cần.
- Thu hồi hoặc thay thế token, secret nếu phát hiện nguy cơ lộ thông tin xác thực.

### 8. Kết quả kỳ vọng
*Cải tiến kỹ thuật*: Hệ thống tự động thu thập, phân tích và cảnh báo chi phí AWS theo chu kỳ; có kiến trúc serverless, event-driven, khả năng chịu lỗi, Web Dashboard trực quan và cơ chế xác thực Cognito bảo vệ dữ liệu chi phí.

*Giá trị dài hạn*: CloudCost Insight là một MVP FinOps có thể tái sử dụng và phát triển thêm trong tương lai, như dự báo chi phí, phân bổ theo phòng ban/dự án, phân tích theo tag, đề xuất tối ưu tài nguyên hoặc tích hợp thêm các kênh cảnh báo.