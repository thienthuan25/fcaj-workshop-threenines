---
title : "Configure HCP Terraform"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.2.2. </b> "
---

#### Create an Organization for the Project

1. Go to https://app.terraform.io/app and sign in. If you do not have an account yet, select **Sign up** to create a new account.

2. On the main page, choose **Create organization** to create a new organization for the project:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_1.png)

3. In the organization creation page, select **Personal**, enter an organization name and your email address, then click **Create organization**.

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_2.png)

4. After the organization is created, it will appear in your organization list:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_3.png)

5. Open the organization you just created. From there, create a **Workspace** to store and manage the Terraform state for this project:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_4.png)

6. Next, add the following two environment variables to the Workspace and mark both of them as **Sensitive** to protect your credentials:

`AWS_ACCESS_KEY_ID`  
`AWS_SECRET_ACCESS_KEY`

+ In the Workspace page, open the **Variables** tab, then click **Add variable**:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_5.png)

+ Enter the required information for each variable:

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_6.png)

![HCP Terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_7.png)

#### Next Content

- [Prepare the Terraform Code](5.2-Prerequisite/5.2.3-Code-terraform/)