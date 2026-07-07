---
title: "Week 5 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.5. </b> "
---

### Week 5 Objectives:

* Establish the infrastructure foundation for the CloudCost Insight project using Infrastructure as Code (Terraform).
* Configure remote state management on HCP Terraform to support team collaboration and preserve infrastructure state.
* Deploy the core infrastructure components: Amazon S3, IAM, Amazon SNS, Amazon SQS (with Dead Letter Queue), and Amazon EventBridge while adhering to AWS security best practices (least privilege and blocking public access).
* Deploy the infrastructure to AWS and verify all provisioned resources through the AWS Management Console.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Set up the Terraform & HCP foundation: <br>&emsp; + Initialize the `terraform/` directory structure and create the `versions.tf` file to configure the AWS provider. <br>&emsp; + Configure HCP Terraform (the `cloud {}` block) to manage the team's remote state. <br>&emsp; + Define input variables in `variables.tf` (AWS region, project_name, alert_email, and cost thresholds). | 08/06/2026 | 08/06/2026 | - Terraform AWS Provider: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs <br> - HCP Terraform Docs: <br> https://developer.hashicorp.com/terraform/cloud-docs |
| Tue | - Deploy the storage and security layer (Amazon S3 + IAM): <br>&emsp; + Create `s3.tf` to provision an S3 bucket for storing cost data, enable Block Public Access, SSE-S3 encryption, versioning, and lifecycle rules for cost optimization. <br>&emsp; + Create `iam.tf` to provision an IAM Role for Lambda following the Principle of Least Privilege. | 09/06/2026 | 09/06/2026 | - Amazon S3 User Guide: <br> https://docs.aws.amazon.com/AmazonS3/latest/userguide/ <br> - IAM Best Practices: <br> https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| Wed | - Deploy the notification and messaging layer (Amazon SNS + Amazon SQS): <br>&emsp; + Create `sns.tf` to provision an SNS Topic and an email subscription for alerts. <br>&emsp; + Create `sqs.tf` to provision the primary queue and a Dead Letter Queue (DLQ) with a redrive policy for failure handling. | 10/06/2026 | 10/06/2026 | - Amazon SNS Developer Guide: <br> https://docs.aws.amazon.com/sns/latest/dg/ <br> - Amazon SQS Developer Guide: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/ |
| Thu | - Deploy the scheduling service and provision the infrastructure: <br>&emsp; + Create `eventbridge.tf` to configure a scheduled EventBridge rule (once per day). <br>&emsp; + Create `outputs.tf` to export important values (ARNs and resource names). <br>&emsp; + Run `terraform init`, `terraform plan`, and `terraform apply` to provision the infrastructure on AWS. | 11/06/2026 | 11/06/2026 | - Amazon EventBridge User Guide: <br> https://docs.aws.amazon.com/eventbridge/latest/userguide/ |
| Fri | - Verify the infrastructure through the AWS Management Console: <br>&emsp; + Verify Amazon S3 (Block Public Access, encryption, versioning), IAM (least privilege), Amazon SNS (email subscription confirmation), Amazon SQS (redrive policy to the DLQ), and Amazon EventBridge (scheduled rule). <br>&emsp; + Capture screenshots of the provisioned resources for the project report. | 12/06/2026 | 12/06/2026 | - AWS Management Console. |

### Week 5 Achievements:

* **Successfully established the Infrastructure as Code foundation:** Completed the Terraform project structure and configured HCP Terraform to manage the remote state. Using a remote state enables centralized infrastructure state management and state locking, providing a solid foundation for collaboration and future project scalability.

* **Successfully deployed the core infrastructure following AWS security best practices:** Defined and provisioned all essential infrastructure components, including Amazon S3 (cost data storage), IAM (access control), Amazon SNS (notifications), Amazon SQS with a Dead Letter Queue (event buffering and failure handling), and Amazon EventBridge (scheduled execution). All resources follow AWS security best practices: the S3 bucket blocks public access and enables encryption, IAM Roles are granted permissions based on the Principle of Least Privilege, and no sensitive information is hard-coded.

* **Implemented a resilient error-handling mechanism:** Configured a Dead Letter Queue (DLQ) with a redrive policy for Amazon SQS, ensuring that failed messages are retained instead of being lost. This demonstrates a fault-tolerant system design capable of handling processing failures gracefully.

* **Successfully deployed and verified the infrastructure:** Executed `terraform apply` successfully to provision the complete infrastructure on AWS. Verified each resource through the AWS Management Console to ensure that every configuration matched the intended design, and confirmed the Amazon SNS email subscription to enable notification delivery. The infrastructure foundation is now fully prepared for developing the Lambda functions in the following weeks.