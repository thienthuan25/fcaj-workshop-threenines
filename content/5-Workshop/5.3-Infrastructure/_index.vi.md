---
title : "Dựng hạ tầng bằng Terraform"
date : 2024-01-01 
weight : 3
chapter : false
pre : " <b> 5.3. </b> "
---

#### Giới thiệu

Trong phần này, chúng ta sẽ dựng các thành phần hạ tầng nền cho hệ thống CloudCost Insight bằng Terraform. Đây là các tài nguyên cốt lõi mà các hàm Lambda sẽ sử dụng ở những phần sau, bao gồm nơi lưu trữ dữ liệu, hàng đợi sự kiện, kênh cảnh bảo và lập lịch.

![S3, IAM, SNS, SQS + DLQ, EventBridge](/fcaj-workshop-threenines/images/5-Workshop/5.3-Infrastructure/Infrastructure_diagram.jpg)

#### Nội dung

- [Khai báo các biến đầu vào](5.3.1-Variables/)
- [Test gateway endpoint](3.2-test-gwe/)