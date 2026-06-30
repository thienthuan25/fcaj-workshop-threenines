---
title: "Worklog Tuần 2"
date: 2026-05-18
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---
### Mục tiêu tuần 2:

* Nắm vững các khái niệm cốt lõi về tính sẵn sàng cao (High Availability), khả năng mở rộng (Scalability) và độ co giãn (Elasticity) trên AWS.
* Hiểu cơ chế hoạt động, các loại Load Balancer và thực hành cấu hình Elastic Load Balancing (cụ thể là Application Load Balancer) để phân phối lưu lượng truy cập an toàn.
* Hiểu và thiết lập Auto Scaling Groups (ASG), nắm bắt các chiến lược mở rộng quy mô (scaling strategies) để đáp ứng linh hoạt tải của hệ thống.
* Làm quen và thực hành với dịch vụ lưu trữ đối tượng Amazon S3: Buckets, Objects, Versioning, và các Storage Classes.
* Nắm bắt kiến thức cơ bản về các dịch vụ cơ sở dữ liệu trên AWS (RDS, Aurora, DynamoDB) và mạng phân phối nội dung (CloudFront, Route 53).

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc                                                                                                                                                                                                                                                                                                                                                                                                                                                    | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                                                                                                                             |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------ | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| 2   | - Tìm hiểu ELB & ASG: <br>&emsp; + High availability, scalability, elasticity <br>&emsp; + Elastic load balancing overview <br>&emsp; + Application load balancer hands on <br>&emsp; + Auto scaling groups overview <br>&emsp; + Auto scaling groups hands on <br>&emsp; + Auto scaling groups strategies <br>&emsp; + Ôn tập trắc nghiệm cho phần này <br> - **Thực hành:** <br>&emsp; + Cấu hình Application Load Balancer <br>&emsp; + Thiết lập ASG | 18/05/2026   | 18/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 3   | - Tìm hiểu Amazon S3 (Lưu trữ đối tượng): <br>&emsp; + S3 Buckets & Objects overview <br>&emsp; + S3 hands on <br>&emsp; + S3 Versioning <br>&emsp; + S3 Storage Classes <br>&emsp; + S3 Security & Encryption <br> - **Thực hành:** <br>&emsp; + Tạo S3 Bucket và tải lên các objects <br>&emsp; + Kích hoạt và kiểm tra S3 Versioning                                                                                                                    | 19/05/2026   | 19/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 4   | - Tìm hiểu Cơ sở dữ liệu (Databases) trên AWS: <br>&emsp; + Relational Database Service (RDS) & Aurora <br>&emsp; + RDS hands on <br>&emsp; + ElastiCache overview <br>&emsp; + DynamoDB (NoSQL) overview <br> - **Thực hành:** <br>&emsp; + Tạo và kết nối với một RDS database instance                                                                                                                                                                    | 20/05/2026   | 20/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 5   | - Tìm hiểu Networking & Content Delivery: <br>&emsp; + Route 53 overview (DNS) <br>&emsp; + Route 53 routing policies <br>&emsp; + CloudFront overview (CDN) <br>&emsp; + S3 Transfer Acceleration <br> - **Thực hành:** <br>&emsp; + Tạo CloudFront distribution kết nối với S3 bucket                                                                                                                                                                      | 21/05/2026   | 21/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 6   | - Tìm hiểu Cloud Integration & Monitoring: <br>&emsp; + SQS, SNS, Kinesis overview <br>&emsp; + CloudWatch metrics & alarms <br>&emsp; + CloudTrail overview <br> - **Thực hành:** <br>&emsp; + Tạo SNS topic và subscribe email <br>&emsp; + Thiết lập CloudWatch alarm để giám sát EC2 billing/CPU                                                                                                                                                         | 22/05/2026   | 22/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026 <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |

### Kết quả đạt được tuần 2:

* Phân biệt rõ ràng và nắm vững ý nghĩa thực tiễn của High Availability (tính sẵn sàng cao), Scalability (khả năng mở rộng) và Elasticity (độ co giãn) trong kiến trúc đám mây.
* Hiểu cách hoạt động của Elastic Load Balancing và đã cấu hình thành công Application Load Balancer để phân phối đều lưu lượng truy cập web giữa các EC2 instances.
* Triển khai thành công Auto Scaling Groups (ASG), nắm được cách ứng dụng các chiến lược Auto Scaling (Target Tracking, Simple, Step Scaling) để hệ thống tự động thêm/bớt instance theo tải thực tế.
* Hoàn thành ôn tập và trả lời tốt các câu hỏi trắc nghiệm củng cố phần ELB & ASG.
* Làm chủ các khái niệm cốt lõi của Amazon S3; đã thực hành tạo Bucket, quản lý Object, cấu hình phân quyền cơ bản và bật tính năng Versioning để bảo vệ dữ liệu.
* Hiểu sự khác biệt giữa các lớp lưu trữ S3 (S3 Storage Classes) để tối ưu hóa chi phí dựa trên tần suất truy cập dữ liệu.
* Phân biệt được các loại cơ sở dữ liệu trên AWS (RDS, Aurora, DynamoDB, ElastiCache) và thực hành khởi tạo thành công một dịch vụ cơ sở dữ liệu quan hệ với RDS.
* Nắm bắt cơ chế phân giải tên miền của Route 53 và cách tối ưu hóa tốc độ tải trang toàn cầu sử dụng mạng phân phối nội dung CloudFront.
* Hiểu tổng quan về các công cụ giám sát, tích hợp hệ thống (CloudWatch, CloudTrail, SNS, SQS) và áp dụng thành công việc tạo cảnh báo (Alarms) cơ bản.