---
title : "Prepare the Terraform Code"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.2.3. </b> "
---

#### Required Tools

In this section, you will work in the WSL2 Ubuntu command line environment. Before you begin, make sure the following tools are installed:

+ **Terraform** version 1.5 or later to provision infrastructure using the Infrastructure as Code approach.
+ **AWS CLI** to interact with AWS services and perform testing from the command line.
+ **Python** version 3.12 or later to develop the Lambda functions.

You can verify that all required tools have been installed successfully by running the following commands:

```bash
terraform version
aws --version
python3 --version
```

![Code terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.3-Code-terraform/code_terraform_1.png)

![Code terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.3-Code-terraform/code_terraform_2.png)

![Code terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.3-Code-terraform/code_terraform_3.png)

#### Configure AWS Credentials for the CLI

In the WSL2 terminal, configure your AWS credentials so that AWS CLI can authenticate and execute commands throughout the deployment and testing process:

```bash
aws configure
```

Enter the following information when prompted:

```
AWS Access Key ID       [None]: <ACCESS_KEY_ID>
AWS Secret Access Key   [None]: <SECRET_ACCESS_KEY>
Default region name     [None]: us-east-1
Default output format   [None]:
```

After completing the configuration, restrict access to the credentials file so that only the current user can read it:

```bash
chmod 600 ~/.aws/credentials
```

Verify that the credentials are working correctly:

```bash
aws sts get-caller-identity
```

#### Configure the Terraform Environment

Create a file named `version.tf` to specify the Terraform version, configure the connection to HCP Terraform, and define the AWS provider. Replace `TEN-TO-CHUC` with the name of your organization and replace `TEN-WORKSPACE` with the name of the workspace you created in HCP Terraform.

```hcl
terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "TEN-TO-CHUC"

    workspaces {
      name = "TEN-WORKSPACE"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }

    # provider archive
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "CloudCost-Insight"
      ManageBy    = "Terraform"
      Environment = var.environment
    }
  }
}
```

#### Connect and Initialize Terraform

In the WSL2 terminal, navigate to the directory containing the Terraform files, then run the following command to authenticate Terraform CLI with HCP Terraform:

```bash
terraform login
```

![Code terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.3-Code-terraform/code_terraform_4.png)

+ Open the URL displayed in the terminal:

![Code terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.3-Code-terraform/code_terraform_5.png)

+ Enter a **Description** if you want to make the token easier to identify.
+ Select an expiration period for the API token.
+ Click **Generate token**.

![Code terraform](/fcaj-workshop-threenines/images/5-Workshop/5.2-Prerequisite/5.2.3-Code-terraform/code_terraform_6.png)

After completing these steps, your working environment is fully configured and ready to deploy the **CloudCost Insight** system in the following sections.