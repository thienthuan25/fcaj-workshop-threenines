---
title : "Cấu hình AWS Credentials"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.2.1. </b> "
---

Vì workshop sử dụng HCP Terraform để chạy Terraform từ xa, bạn cần thêm AWS credentials vào Workspace Variables trên HCP thay vì cấu hình trực tiếp trong code.

#### Tạo Access key cho IAM user trong AWS Console
1. Đăng nhập vào cửa số Console AWS.
2. Ở góc trên cùng bên phải, chọn vào tên tài khoản của bạn, sau đó chọn **Security Credentials**:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_1.png)

3. Sau khi cửa sổ hiện ra, ở mục **Access keys**, chọn **Create access key**:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_2.png)

4. Chọn **Use case** là **CLI**, xác nhận và bấm **Next**:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_3.png)

5. Có thể đặt mô tả cho access key nếu muốn, sau đó bấm **Create access key**:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_4.png)

6. Ghi lại **AWS Access Key ID** và **AWS Secret Access Key** của bạn. Bạn sẽ cần chúng để cấu hình AWS credentials trong HCP Terraform:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_5.png)

#### Nội dung tiếp theo

- [Cấu hình HCP Terraform](5.2-Prerequisite/5.2.2-HCP-Terraform/)
