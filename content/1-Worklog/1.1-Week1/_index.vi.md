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

* Kết nối, làm quen với các thành viên trong First Cloud AI Journey, nắm rõ nội quy và quy định tại đơn vị thực tập.
* Hiểu nền tảng về IAM (Identity and Access Management) — thành phần cốt lõi cho việc quản lý quyền truy cập trên AWS.
* Thực hành tạo và quản lý Users, Groups, Policies, Roles trong IAM.
* Nắm vững cách bảo mật tài khoản AWS thông qua MFA và các công cụ bảo mật IAM (IAM Security Tools).
* Làm quen với AWS Access Keys, AWS CLI, AWS CloudShell và cách sử dụng SDK để tương tác với AWS bằng dòng lệnh.
* Hiểu rõ mô hình trách nhiệm chung (Shared Responsibility Model) áp dụng cho IAM.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc                                                                                                                                                                                   | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| 2   | - Làm quen với AWS console <br> - Đọc và lưu ý các nội quy, quy định tại đơn vị thực tập                                                                                            | 11/05/2026   | 11/05/2026      | https://hcm-rules.awsfcaj.com/1-regulations/ 
| 3   | - Lên văn phòng học tập trực tiếp <br> - Tìm hiểu IAM (Identity and Access Management): <br>&emsp; + IAM Introduction: Users, Groups, Policies <br>&emsp; + IAM Users & Groups Hands on <br>&emsp; + AWS console simultaneous sign-in <br> - **Thực hành:** <br>&emsp; + Tạo IAM Users <br>&emsp; + Tạo IAM Groups và gán Users vào Group | 12/05/2026   | 12/05/2026      | Ultimate Certified Cloud Practitioner CLF-C02 2026 |
| 4   | - Tìm hiểu IAM Policies: <br>&emsp; + IAM Policies <br>&emsp; + IAM Policies hands on <br> - Tìm hiểu IAM MFA: <br>&emsp; + IAM MFA Overview <br>&emsp; + IAM MFA Hands on <br> - **Thực hành:** <br>&emsp; + Tạo và gắn custom policy cho User/Group <br>&emsp; + Bật MFA cho tài khoản IAM | 13/05/2026   | 13/05/2026      | Ultimate Certified Cloud Practitioner CLF-C02 2026 |
| 5   | - Tìm hiểu AWS Access Keys, CLI và SDK: <br>&emsp; + AWS Access Keys, CLI and SDK <br>&emsp; + AWS CLI setup on Windows, Linux <br>&emsp; + AWS CLI hands on <br>&emsp; + AWS CloudShell <br> - **Thực hành:** <br>&emsp; + Tạo Access Key <br>&emsp; + Cài đặt và cấu hình AWS CLI <br>&emsp; + Sử dụng AWS CloudShell trên console | 14/05/2026   | 14/05/2026      | Ultimate Certified Cloud Practitioner CLF-C02 2026 |
| 6   | - Tìm hiểu IAM Roles và các công cụ bảo mật: <br>&emsp; + IAM Roles for AWS Services <br>&emsp; + IAM Roles hands on <br>&emsp; + IAM security tools <br>&emsp; + IAM security tools hands on <br>&emsp; + IAM best practices <br>&emsp; + Shared Responsibility model for IAM <br> - **Thực hành:** <br>&emsp; + Tạo IAM Role gán cho AWS service <br>&emsp; + Sử dụng IAM Credential Report & Access Advisor <br> - Ôn tập trắc nghiệm tổng hợp về IAM | 15/05/2026   | 15/05/2026      | Ultimate Certified Cloud Practitioner CLF-C02 2026 |


### Kết quả đạt được tuần 1:

* Nắm rõ nội quy, quy định tại đơn vị thực tập và làm quen với AWS Management Console.

* Hiểu rõ các khái niệm cốt lõi của IAM:
  * Users, Groups, Policies, Roles
  * Cơ chế xác thực và phân quyền trên AWS

* Đã tạo và quản lý thành công IAM Users, IAM Groups, đồng thời thực hành đăng nhập đồng thời nhiều phiên trên AWS console.

* Hiểu và thực hành tạo, gắn IAM Policies (managed policy & custom policy) cho Users/Groups theo nguyên tắc least privilege.

* Bật và cấu hình thành công MFA (Multi-Factor Authentication) cho tài khoản IAM, tăng cường bảo mật đăng nhập.

* Hiểu về AWS Access Keys, CLI và SDK; cài đặt và cấu hình thành công AWS CLI trên hệ điều hành Windows/Linux, bao gồm:
  * Access Key
  * Secret Key
  * Region mặc định

* Làm quen và thực hành sử dụng AWS CloudShell trực tiếp trên console mà không cần cài đặt local.

* Hiểu và thực hành tạo IAM Roles để gán quyền cho các AWS service, thay vì sử dụng access key cố định.

* Làm quen với các công cụ bảo mật IAM như IAM Credential Report, IAM Access Advisor và nắm được các best practices khi quản lý IAM.

* Hiểu rõ mô hình Shared Responsibility Model áp dụng riêng cho IAM, phân biệt rõ trách nhiệm của AWS và của khách hàng.

* Hoàn thành ôn tập trắc nghiệm tổng hợp về IAM, củng cố kiến thức đã học trong tuần.