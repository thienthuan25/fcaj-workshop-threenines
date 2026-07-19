---
title : "Prerequisites"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

#### General Requirements

Before starting this workshop, make sure you have prepared the following:

+ An AWS account with AWS Cost Explorer enabled. Cost Explorer must be enabled in the Billing console before the API can retrieve cost data.
+ The AWS Region used throughout this workshop is N. Virginia (us-east-1).
+ An HCP Terraform account at app.terraform.io for remote state management.

#### Required Tools

+ **Terraform** version 1.5 or later to provision infrastructure using Infrastructure as Code.
+ **AWS CLI** to interact with and test AWS services from the command line.
+ **Python** version 3.12 for developing the Lambda functions.
+ A source code editor such as Visual Studio Code.

#### IAM Permissions

Attach the following IAM policy to your AWS IAM user so that it has sufficient permissions to deploy and clean up the resources used in this workshop. This policy provides the minimum permissions required for the AWS services used by CloudCost Insight.

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
        "ce:GetCostAndUsage",
        "secretsmanager:CreateSecret",
        "secretsmanager:DeleteSecret",
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue",
        "secretsmanager:PutSecretValue",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:PassRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:GetRolePolicy",
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