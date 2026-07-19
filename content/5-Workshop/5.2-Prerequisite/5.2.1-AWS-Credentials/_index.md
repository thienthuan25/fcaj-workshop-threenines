---
title : "Configure AWS Credentials"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.2.1. </b> "
---

Since this workshop uses HCP Terraform to run Terraform remotely, you need to add your AWS credentials to the Workspace Variables in HCP instead of configuring them directly in the code.

#### Create an Access Key for an IAM User in the AWS Console

1. Sign in to the AWS Management Console.
2. In the upper right corner, click your account name, then select **Security Credentials**:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_1.png)

3. After the page opens, under **Access keys**, choose **Create access key**:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_2.png)

4. Select **CLI** as the **Use case**, confirm your selection, then click **Next**:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_3.png)

5. Optionally enter a description for the access key, then click **Create access key**:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_4.png)

6. Save your **AWS Access Key ID** and **AWS Secret Access Key**. You will need them to configure AWS credentials in HCP Terraform:

![Credentials](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.1-AWS-credentials/credentials_5.png)

#### Next Content

- [Configure HCP Terraform](5.2.2-HCP-Terraform)