---
title : "Configure HCP Terraform"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.2.2. </b> "
---

#### Create an Organization for the Project

1. Go to [https://app.terraform.io/app](https://app.terraform.io/app) and sign in. If you do not already have an account, click **Sign up** to create a new one.

2. On the main interface, select **Create organization** to start creating an organization for the project.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_1.png)

3. In the **Create organization** window, choose the **Personal** organization type, enter the organization name and email address, then click **Create organization**.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_2.png)

4. After the organization is created, you will see it listed on the Organizations page.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_3.png)

5. Open the organization you just created. Here, we will create a **Workspace** to store and manage the Terraform state for the project.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_4.png)

6. Select **Default Project**.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_8.png)

7. Choose **CLI-Driven Workflow**.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_9.png)

8. Enter a name for the **Workspace**, then click **Create**.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_10.png)

9. Next, add the following two environment variables to the Workspace and mark them as **Sensitive** to protect your AWS credentials.

+ `AWS_ACCESS_KEY_ID`
+ `AWS_SECRET_ACCESS_KEY`

+ In the Workspace, open the **Variables** tab, then click **Add variable**.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_5.png)

+ Enter the required information for each variable.

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_6.png)

![HCP Terraform](/workshop-fcaj-intern/images/5-Workshop/5.2-Prerequisite/5.2.2-HCP-Terraform/hcp_terraform_7.png)

#### Next Section

- [Prepare the Terraform Code](../5.2.3-Code-terraform/)