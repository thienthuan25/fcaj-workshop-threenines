---
title : "Cấu hình HCP Terraform"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.2.2. </b> "
---


#### Tạo Organization cho dự án

1. Truy cập [https://app.terraform.io/app](https://app.terraform.io/app) và đăng nhập. Nếu chưa có tài khoản, bạn hãy chọn **Sign up** để tạo tài khoản mới.

2. Tại giao diện chính, chọn **Create organization** để bắt đầu tạo một tổ chức cho dự án:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_1.png)

3. Ở cửa sổ tạo organization, bạn chọn loại **Personal**, đặt tên cho organization, điền email và sau đó nhấn **Create organization**.

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_2.png)

4. Sau khi tạo xong, bạn sẽ thấy organization vừa được tạo hiển thị trong danh sách:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_3.png)

5. Truy cập vào organization vừa tạo. Tại đây, chúng ta sẽ tạo một **Workspace** để lưu trữ và quản lý trạng thái của mã nguồn Terraform:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_4.png)

6. Tiếp theo, chúng ta thêm hai biến môi trường vào Workspace và đánh dấu chúng là **Sensitive** để bảo mật:

`AWS_ACCESS_KEY_ID`,
`AWS_SECRET_ACCESS_KEY`

+ Trong cửa sổ của Workspace, bạn chọn tab **Variables**, sau đó nhấn **Add variable**:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_5.png)

+ Lần lượt điền các thông tin cho từng biến:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_6.png)

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_7.png)

#### Nội dung tiếp theo

- [Chuẩn bị Code Terraform](../5.2.3-Code-terraform/)