---
title: "Worklog Tuần 3"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.3. </b> "
---
<!-- {{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}} -->


### Mục tiêu tuần 3:

* Hiểu các công cụ triển khai và quản lý hạ tầng quy mô lớn trên AWS: CloudFormation, CDK, Beanstalk, CodePipeline, Systems Manager.
* Nắm được cách tận dụng hạ tầng toàn cầu của AWS: Route 53, CloudFront, Global Accelerator, Outposts, Local Zones.
* Hiểu các dịch vụ tích hợp đám mây: SQS, SNS, Kinesis, Amazon MQ.
* Nắm vững các công cụ giám sát đám mây: CloudWatch, EventBridge, CloudTrail, X-Ray, AWS Health Dashboard.
* Hiểu về bảo mật và tuân thủ trên AWS: WAF, Shield, KMS, Secrets Manager, GuardDuty, Inspector, IAM Access Analyzer và các dịch vụ liên quan.
* Hiểu kiến trúc mạng AWS: VPC, Subnet, Internet Gateway, NAT, Security Groups, NACL, VPN, Direct Connect, Transit Gateway.
* Nắm tổng quan về các dịch vụ Machine Learning của AWS: Rekognition, Transcribe, Polly, SageMaker, Kendra, Textract và các dịch vụ liên quan.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc                                                                                                                                                                                   | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| 2   | - Tìm hiểu Deployments & Managing Infrastructure at Scale: <br>&emsp; + CloudFormation overview <br>&emsp; + CloudFormation hands on <br>&emsp; + CDK overview <br>&emsp; + Beanstalk overview <br>&emsp; + Beanstalk hands on <br>&emsp; + CodeDeploy overview <br>&emsp; + CodeCommit overview <br>&emsp; + CodeBuild overview <br>&emsp; + CodePipeline overview <br>&emsp; + CodeArtifact overview <br>&emsp; + Systems Manager (SSM) overview <br>&emsp; + SSM Session Manager <br>&emsp; + SSM Parameter Store <br> - **Thực hành:** <br>&emsp; + Tạo stack với CloudFormation <br>&emsp; + Triển khai ứng dụng với Elastic Beanstalk <br>&emsp; + Sử dụng SSM Session Manager kết nối EC2 không cần SSH <br> - Ôn tập trắc nghiệm tổng hợp | 25/05/2026   | 25/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 3   | - Tìm hiểu Leveraging the AWS Global Infrastructure: <br>&emsp; + Why global application? <br>&emsp; + Route 53 overview <br>&emsp; + Route 53 hands on <br>&emsp; + CloudFront overview <br>&emsp; + CloudFront hands on <br>&emsp; + S3 Transfer Acceleration <br>&emsp; + AWS Global Accelerator <br>&emsp; + AWS Outposts <br>&emsp; + AWS Wavelength <br>&emsp; + AWS Local Zones <br>&emsp; + Global applications architecture <br> - Tìm hiểu Cloud Integrations: <br>&emsp; + Cloud integration overview <br>&emsp; + SQS overview <br>&emsp; + SQS hands on <br>&emsp; + Kinesis overview <br>&emsp; + SNS overview <br>&emsp; + SNS hands on <br>&emsp; + Amazon MQ overview <br> - **Thực hành:** <br>&emsp; + Cấu hình Route 53 <br>&emsp; + Tạo CloudFront distribution <br>&emsp; + Tạo SQS queue và gửi/nhận message <br>&emsp; + Tạo SNS topic và subscription | 26/05/2026   | 26/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 4   | - Tìm hiểu Cloud Monitoring: <br>&emsp; + CloudWatch Metrics & CloudWatch Alarms <br>&emsp; + CloudWatch Metrics & CloudWatch Alarms hands on <br>&emsp; + CloudWatch Logs overview <br>&emsp; + CloudWatch Logs hands on <br>&emsp; + EventBridge overview <br>&emsp; + EventBridge hands on <br>&emsp; + CloudTrail overview <br>&emsp; + CloudTrail hands on <br>&emsp; + X-Ray overview <br>&emsp; + AWS Health Dashboard <br>&emsp; + AWS Health Dashboard hands on <br> - Tìm hiểu Security & Compliance: <br>&emsp; + Shared Responsibility Model: reminders & examples <br>&emsp; + DDoS protection: WAF & Shield <br>&emsp; + AWS Network Firewall <br>&emsp; + AWS Firewall Manager <br>&emsp; + Penetration testing <br>&emsp; + Encryption with KMS & CloudHSM <br>&emsp; + Encryption with KMS & CloudHSM hands on <br>&emsp; + AWS Certificate Manager (ACM) overview <br>&emsp; + Secrets Manager overview <br>&emsp; + Artifact overview <br>&emsp; + GuardDuty overview <br>&emsp; + Inspector overview <br>&emsp; + Config overview <br>&emsp; + Macie overview <br>&emsp; + Security Hub overview <br>&emsp; + Amazon Detective overview <br>&emsp; + AWS Abuse <br>&emsp; + Root user privileges <br>&emsp; + IAM Access Analyzer <br> - **Thực hành:** <br>&emsp; + Tạo CloudWatch Alarm gửi thông báo qua SNS <br>&emsp; + Tạo EventBridge rule trigger Lambda <br>&emsp; + Tạo KMS key và mã hóa S3 object <br>&emsp; + Bật GuardDuty và xem findings | 27/05/2026   | 27/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 5   | - Tìm hiểu VPC & Networking: <br>&emsp; + VPC overview <br>&emsp; + IP address in AWS <br>&emsp; + VPC, Subnet, Internet Gateway & NAT Gateways <br>&emsp; + VPC, Subnet, Internet Gateway & NAT Gateways hands on <br>&emsp; + Security Groups & Network Access Control List (NACL) <br>&emsp; + VPC Flow Logs & VPC Peering <br>&emsp; + VPC Endpoints - Interface & Gateway (S3 & DynamoDB) <br>&emsp; + PrivateLink <br>&emsp; + Direct Connect & Site-to-Site VPN <br>&emsp; + Client VPN <br>&emsp; + Transit Gateway overview <br> - **Thực hành:** <br>&emsp; + Tạo VPC với public và private subnet <br>&emsp; + Cấu hình Internet Gateway và NAT Gateway <br>&emsp; + Cấu hình Security Group và NACL <br>&emsp; + Tạo VPC Endpoint cho S3 | 28/05/2026   | 28/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 6   | - Tìm hiểu Machine Learning trên AWS: <br>&emsp; + Rekognition overview <br>&emsp; + Transcribe overview <br>&emsp; + Polly overview <br>&emsp; + Translate overview <br>&emsp; + Lex + Connect overview <br>&emsp; + Comprehend overview <br>&emsp; + SageMaker AI overview <br>&emsp; + Kendra overview <br>&emsp; + Personalize overview <br>&emsp; + Textract overview <br> - Ôn tập và tổng kết toàn bộ kiến thức 3 tuần | 29/05/2026   | 29/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |


### Kết quả đạt được tuần 3:

* Hiểu các công cụ triển khai và quản lý hạ tầng ở quy mô lớn:
  * CloudFormation để định nghĩa hạ tầng dưới dạng code (IaC)
  * CDK (Cloud Development Kit) như một lớp trừu tượng cao hơn trên CloudFormation
  * Elastic Beanstalk để triển khai ứng dụng nhanh mà không cần quản lý hạ tầng
  * Bộ công cụ CI/CD của AWS: CodeCommit, CodeBuild, CodeDeploy, CodePipeline, CodeArtifact
  * Systems Manager (SSM): quản lý EC2 không cần SSH thông qua Session Manager, lưu trữ cấu hình với Parameter Store

* Nắm được lý do và cách triển khai ứng dụng toàn cầu trên AWS:
  * Route 53 cho DNS routing
  * CloudFront như CDN phân phối nội dung toàn cầu
  * S3 Transfer Acceleration và AWS Global Accelerator để tăng tốc độ truyền tải
  * AWS Outposts, Wavelength, Local Zones cho các use case đặc thù

* Hiểu các dịch vụ tích hợp và truyền thông điệp:
  * SQS (Simple Queue Service) cho hàng đợi tin nhắn
  * SNS (Simple Notification Service) cho pub/sub messaging
  * Kinesis cho xử lý dữ liệu streaming theo thời gian thực
  * Amazon MQ cho message broker tương thích với các giao thức mở

* Nắm vững các công cụ giám sát đám mây:
  * CloudWatch Metrics, Alarms, Logs để theo dõi và cảnh báo tài nguyên
  * EventBridge để xây dựng các luồng xử lý sự kiện
  * CloudTrail để kiểm tra lịch sử API call
  * X-Ray để truy vết và phân tích hiệu suất ứng dụng
  * AWS Health Dashboard để theo dõi trạng thái dịch vụ AWS

* Hiểu toàn diện về bảo mật và tuân thủ trên AWS:
  * WAF, Shield và Network Firewall để chống DDoS và tấn công mạng
  * KMS và CloudHSM để mã hóa dữ liệu
  * Secrets Manager để quản lý thông tin bí mật
  * GuardDuty, Inspector, Macie, Security Hub, Detective để phát hiện và điều tra mối đe dọa
  * IAM Access Analyzer, Config, Artifact cho kiểm soát và tuân thủ

* Hiểu kiến trúc mạng AWS:
  * VPC, Subnet (public/private), Internet Gateway, NAT Gateway
  * Phân biệt Security Group và NACL
  * VPC Flow Logs, VPC Peering, VPC Endpoints
  * PrivateLink, Direct Connect, Site-to-Site VPN, Client VPN và Transit Gateway

* Nắm tổng quan các dịch vụ Machine Learning của AWS:
  * Rekognition (nhận diện hình ảnh/video), Transcribe (speech-to-text), Polly (text-to-speech), Translate
  * Lex + Connect cho chatbot và contact center
  * Comprehend (xử lý ngôn ngữ tự nhiên), SageMaker AI (xây dựng và huấn luyện ML model)
  * Kendra (tìm kiếm thông minh), Personalize (gợi ý cá nhân hóa), Textract (trích xuất văn bản từ tài liệu)

* Hoàn thành ôn tập và tổng kết toàn bộ kiến thức AWS Cloud Practitioner sau 3 tuần học.
