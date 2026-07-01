---
title: "Worklog Tuần 1"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---
<!-- {{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}} -->


### Mục tiêu tuần 1:

* Hiểu nền tảng về IAM (Identity and Access Management): Users, Groups, Policies, Roles, MFA và các công cụ bảo mật IAM.
* Làm quen với AWS Access Keys, AWS CLI, AWS CloudShell và mô hình Shared Responsibility cho IAM.
* Hiểu và thực hành các kiến thức cơ bản về EC2: instance types, security groups, SSH, EC2 instance roles, purchasing options.
* Hiểu về EC2 Instance Storage: EBS, EBS Snapshots, AMI, EC2 Image Builder, Instance Store và Amazon FSx.
* Thiết lập AWS Budget để theo dõi và kiểm soát chi phí trong quá trình thực hành.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc                                                                                                                                                                                   | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| 2   | - Tìm hiểu IAM (Identity and Access Management): <br>&emsp; + IAM Introduction: Users, Groups, Policies <br>&emsp; + IAM Users & Groups Hands on <br>&emsp; + AWS console simultaneous sign-in <br>&emsp; + IAM Policies <br>&emsp; + IAM Policies hands on <br>&emsp; + IAM MFA overview <br>&emsp; + IAM MFA hands on <br> - **Thực hành:** <br>&emsp; + Tạo IAM Users, Groups <br>&emsp; + Tạo và gắn IAM Policies <br>&emsp; + Bật MFA cho tài khoản IAM | 11/05/2026   | 11/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 3   | - Học tập trực tiếp tại văn phòng <br> - Tìm hiểu AWS Access Keys, CLI, SDK và IAM Roles: <br>&emsp; + AWS Access Keys, CLI and SDK <br>&emsp; + AWS CLI setup on Windows and Linux <br>&emsp; + AWS CLI hands on <br>&emsp; + AWS CloudShell <br>&emsp; + IAM roles for AWS services <br>&emsp; + IAM roles hands on <br>&emsp; + IAM security tools <br>&emsp; + IAM security tools hands on <br>&emsp; + Shared responsibility model for IAM <br> - **Thực hành:** <br>&emsp; + Cài đặt và cấu hình AWS CLI <br>&emsp; + Sử dụng AWS CloudShell <br>&emsp; + Tạo IAM Role cho AWS service | 12/05/2026   | 12/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 4   | - Tìm hiểu EC2 (Elastic Compute Cloud): <br>&emsp; + AWS budget setup <br>&emsp; + EC2 basics <br>&emsp; + EC2 instance types basics <br>&emsp; + Security groups & classic ports overview <br>&emsp; + Security groups hands on <br> - **Thực hành:** <br>&emsp; + Thiết lập AWS Budget <br>&emsp; + Tạo EC2 instance với EC2 User Data để dựng website <br>&emsp; + Cấu hình Security Group | 13/05/2026   | 13/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 5   | - Tìm hiểu EC2 (Elastic Compute Cloud) nâng cao: <br>&emsp; + SSH overview <br>&emsp; + How to SSH using Windows <br>&emsp; + How to SSH using Linux <br>&emsp; + SSH troubleshooting <br>&emsp; + EC2 Instance Connect <br>&emsp; + EC2 instance roles demo <br>&emsp; + EC2 instance purchasing options <br>&emsp; + Shared responsibility model for EC2 <br> - **Thực hành:** <br>&emsp; + SSH vào EC2 từ Windows và Linux <br>&emsp; + Sử dụng EC2 Instance Connect <br>&emsp; + Gán IAM Role cho EC2 instance | 14/05/2026   | 14/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| 6   | - Tìm hiểu EC2 Instance Storage: <br>&emsp; + EBS overview <br>&emsp; + About EBS Multi-Attach <br>&emsp; + EBS hands on <br>&emsp; + EBS snapshots overview <br>&emsp; + EBS snapshot hands on <br>&emsp; + AMI overview <br>&emsp; + AMI hands on <br>&emsp; + EC2 Image Builder overview <br>&emsp; + EC2 Instance Store <br>&emsp; + Shared responsibility model for EC2 storage <br>&emsp; + Amazon FSx overview <br> - **Thực hành:** <br>&emsp; + Tạo và gắn EBS volume <br>&emsp; + Tạo EBS Snapshot <br>&emsp; + Tạo AMI từ instance | 15/05/2026   | 15/05/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |


### Kết quả đạt được tuần 1:

* Hiểu rõ các khái niệm cốt lõi của IAM:
  * Users, Groups, Policies, Roles
  * Cơ chế xác thực và phân quyền trên AWS

* Đã tạo và quản lý thành công IAM Users, IAM Groups, đồng thời thực hành đăng nhập đồng thời nhiều phiên trên AWS console.

* Hiểu và thực hành tạo, gắn IAM Policies cho Users/Groups; bật và cấu hình MFA cho tài khoản IAM, tăng cường bảo mật đăng nhập.

* Hiểu về AWS Access Keys, CLI, SDK; cài đặt và cấu hình thành công AWS CLI trên Windows/Linux, gồm:
  * Access Key
  * Secret Key
  * Region mặc định

* Làm quen và thực hành sử dụng AWS CloudShell trực tiếp trên console.

* Hiểu và thực hành tạo IAM Roles để gán quyền cho AWS services, làm quen với các IAM security tools (Credential Report, Access Advisor) và mô hình Shared Responsibility cho IAM.

* Thiết lập thành công AWS Budget để theo dõi chi phí trong quá trình học và thực hành.

* Hiểu các khái niệm cơ bản của EC2:
  * Instance types
  * Security Groups & các cổng (ports) phổ biến
  * EC2 User Data

* Tạo thành công EC2 instance, sử dụng EC2 User Data để tự động dựng một website đơn giản; cấu hình Security Group cho phép truy cập đúng cổng cần thiết.

* Thực hành kết nối SSH vào EC2 từ cả Windows và Linux, biết cách xử lý các lỗi SSH thường gặp; sử dụng EC2 Instance Connect như một phương thức kết nối thay thế.

* Hiểu về EC2 Instance Roles, các tùy chọn purchasing (On-Demand, Reserved, Spot, Savings Plans...) và mô hình Shared Responsibility áp dụng cho EC2.

* Hiểu về EC2 Instance Storage:
  * EBS (Elastic Block Store) và tính năng Multi-Attach
  * EBS Snapshots
  * AMI (Amazon Machine Image) và EC2 Image Builder
  * EC2 Instance Store
  * Amazon FSx
  * Mô hình Shared Responsibility cho EC2 storage

* Thực hành tạo, gắn EBS volume vào EC2 instance, tạo EBS Snapshot để sao lưu dữ liệu và tạo AMI từ instance đang chạy để phục vụ việc nhân bản/khởi tạo instance mới.
