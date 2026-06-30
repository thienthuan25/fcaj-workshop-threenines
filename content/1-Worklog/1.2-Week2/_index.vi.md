---
title: "Worklog Tuần 2"
date: 2026-05-18
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---
### Mục tiêu tuần 2:

* Hiểu các khái niệm cốt lõi về tính sẵn sàng cao (High Availability), khả năng mở rộng (Scalability) và độ co giãn (Elasticity). Nắm vững và thực hành với Elastic Load Balancing (ELB) cùng Auto Scaling Groups (ASG).
* Khám phá chuyên sâu về Amazon S3: quản lý dữ liệu, bảo mật (Bucket Policy), Hosting Website tĩnh, Versioning, Replication và các lớp lưu trữ (Storage Classes).
* Nắm bắt các phương thức di chuyển dữ liệu quy mô lớn thông qua AWS Snow Family và Storage Gateway.
* Hiểu và thực hành triển khai các dịch vụ cơ sở dữ liệu quan hệ (RDS, Aurora) và NoSQL (DynamoDB, ElastiCache). Nắm được tổng quan các dịch vụ Phân tích dữ liệu (Analytics) trên AWS.
* Làm quen với hệ sinh thái tính toán đa dạng ngoài EC2: Containers (Docker, ECS, EKS), kiến trúc Serverless (AWS Lambda, API Gateway) và AWS Lightsail.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                                                            |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ------------------------------------------------------------------------- |
| 2   | - Tìm hiểu ELB & ASG: <br>&emsp; + High availability, scalability, elasticity <br>&emsp; + Elastic load balancing overview <br>&emsp; + Auto scaling groups overview <br>&emsp; + Auto scaling groups strategies <br>&emsp; + Ôn tập trắc nghiệm cho phần này <br> - **Thực hành:** <br>&emsp; + Application load balancer hands on <br>&emsp; + Auto scaling groups hands on                                                                                                                                                                               | 18/05/2026   | 18/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 3   | - Tìm hiểu S3 & Snow Family: <br>&emsp; + S3 overview & security: bucket policy <br>&emsp; + S3 website, versioning, replication overview <br>&emsp; + S3 storage classes & express one zone <br>&emsp; + S3 encryption & IAM access analyzer for S3 <br>&emsp; + Shared responsibility model for S3 <br>&emsp; + AWS Snow family overview & Snowball edge pricing <br>&emsp; + Storage gateway overview <br>&emsp; + Ôn tập trắc nghiệm <br> - **Thực hành:** <br>&emsp; + S3 hands on & bucket policy hands on <br>&emsp; + S3 website, versioning, replication hands on <br>&emsp; + S3 storage classes hands on <br>&emsp; + AWS Snow family hands on | 19/05/2026   | 19/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 4   | - Tìm hiểu Database & Analytics (Phần 1): <br>&emsp; + RDS & Aurora overview <br>&emsp; + RDS deployments options <br>&emsp; + ElastiCache overview <br>&emsp; + DynamoDB overview & global tables <br>&emsp; + Redshift Overview <br> - **Thực hành:** <br>&emsp; + RDS hands on <br>&emsp; + DynamoDB hands on                                                                                                                                                                                                                                            | 20/05/2026   | 20/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 5   | - Tìm hiểu Database & Analytics (Phần 2): <br>&emsp; + EMR overview <br>&emsp; + Athena overview <br>&emsp; + QuickSight overview <br>&emsp; + DocumentDB Overview <br>&emsp; + Neptune Overview <br>&emsp; + Timestream Overview <br>&emsp; + Managed Blockchain Overview <br>&emsp; + Glue Overview <br>&emsp; + DMS Overview                                                                                                                                                                                                                               | 21/05/2026   | 21/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 6   | - Tìm hiểu Other compute services (ECS, Lambda, Batch, Lightsail): <br>&emsp; + Docker overview <br>&emsp; + ECS, Fargate & ECR overview <br>&emsp; + Amazon EKS overview <br>&emsp; + Serverless introduction & API gateway overview <br>&emsp; + Lambda overview <br>&emsp; + Batch overview <br>&emsp; + Lightsail overview <br> - **Thực hành:** <br>&emsp; + Lambda hands on <br>&emsp; + Lightsail hands on                                                                                                                                         | 22/05/2026   | 22/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |

### Kết quả đạt được tuần 2:

* Hiểu rõ và phân biệt được các khái niệm kiến trúc quan trọng: High Availability, Scalability và Elasticity.
* Cấu hình và triển khai thành công Application Load Balancer (ALB) để phân phối traffic.
* Thiết lập Auto Scaling Groups (ASG) kết hợp các chiến lược mở rộng tự động để đảm bảo tính khả dụng của ứng dụng.
* Làm chủ các tính năng của Amazon S3: 
  * Tạo bucket, cấu hình Bucket Policy để bảo mật dữ liệu.
  * Thiết lập S3 làm nơi lưu trữ website tĩnh (Static Website Hosting).
  * Bật và quản lý S3 Versioning, cấu hình S3 Replication.
  * Nắm vững các S3 Storage Classes, S3 Express One Zone và cơ chế mã hóa (Encryption).
* Nắm được các giải pháp truyền tải/lưu trữ dữ liệu hybrid với AWS Snow Family và AWS Storage Gateway, hiểu rõ chi phí (pricing) của Snowball Edge.
* Hoàn thành triển khai và thực hành quản trị cơ bản cơ sở dữ liệu trên AWS:
  * Khởi tạo thành công Amazon RDS và nắm được các tùy chọn triển khai.
  * Thực hành với Amazon DynamoDB và cấu hình Global Tables.
* Có cái nhìn tổng quan toàn diện về hệ sinh thái Database và Data Analytics trên AWS, phân biệt được use-case của: ElastiCache, Redshift, EMR, Athena, QuickSight, DocumentDB, Neptune, Timestream, Managed Blockchain, Glue và DMS.
* Hiểu nền tảng về Container (Docker) và các dịch vụ quản lý container của AWS (ECS, Fargate, ECR, EKS).
* Nắm bắt mô hình điện toán không máy chủ (Serverless), thực hành tạo và chạy AWS Lambda functions thành công.
* Hiểu tổng quan về Amazon API Gateway, AWS Batch và thực hành khởi tạo nhanh máy chủ ảo với Amazon Lightsail.
* Vượt qua các bài ôn tập trắc nghiệm đánh giá năng lực cho phần nội dung tính toán co giãn (ELB & ASG) và lưu trữ (S3).