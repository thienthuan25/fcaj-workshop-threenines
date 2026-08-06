---
title : "Prerequisites"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

#### General requirements

Before starting the workshop, you need to prepare the following requirements:

- An AWS account with permission to create and delete resources.
- The Region used in this workshop is N. Virginia (`us-east-1`).
- AWS Cost Explorer must be enabled in the AWS Billing Console. Note that Cost Explorer data may have a delay, so the workshop also uses simulated cost data for testing.
- An HCP Terraform account at [app.terraform.io](https://app.terraform.io) to manage remote state and perform Terraform remote runs.
- A GitHub account and a GitHub repository to store source code, create Pull Requests, and configure CI/CD.
- An email address that can receive emails from Amazon SNS to test cost alerts and incident alerts.

#### Tools to install

- **Git** to manage source code, create branches, commit, and push code to GitHub.
- **Terraform** (version 1.5 or later) to deploy infrastructure using Infrastructure as Code.
- **AWS CLI** to configure AWS credentials, operate, and test AWS services from the command line.
- **Python** (version 3.12) to develop, run unit tests, and check Lambda functions.
- **Node.js** to check the JavaScript syntax of the Web Dashboard.
- **Hugo Extended** if you want to run and check the Workshop locally before pushing it to GitHub Pages.
- A source code editor such as Visual Studio Code.

#### IAM permissions

Attach the following IAM permission policy to the AWS IAM User or IAM Role used to deploy the workshop. This policy grants permissions for the services used by CloudCost Insight, including Lambda, S3, SQS, SNS, EventBridge, CloudWatch, API Gateway, CloudFront, and Amazon Cognito.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CloudCostInsightDeploy",
      "Effect": "Allow",
      "Action": [
        "lambda:*",
        "s3:*",
        "sqs:*",
        "sns:*",
        "events:*",
        "cloudwatch:*",
        "logs:*",
        "apigateway:*",
        "cloudfront:*",
        "cognito-idp:*",
        "ce:GetCostAndUsage",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:PassRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:GetRolePolicy",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:TagRole",
        "iam:UntagRole",
        "iam:CreatePolicy",
        "iam:DeletePolicy",
        "iam:GetPolicy",
        "iam:ListRoles",
        "iam:ListPolicyVersions"
      ],
      "Resource": "*"
    }
  ]
}
```

#### Content

1. [Configure AWS Credentials](5.2.1-AWS-Credentials/)
2. [Configure HCP Terraform](5.2.2-HCP-Terraform/)
3. [Prepare the Terraform Code](5.2.3-Code-terraform/)