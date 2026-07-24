---
title: "Week 5 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.5. </b> "
---

### Week 5 Objectives:

* Establish the infrastructure foundation for the CloudCost Insight project using Infrastructure as Code (Terraform).
* Configure remote state management with HCP Terraform to support team collaboration and preserve infrastructure state.
* Deploy the core infrastructure components: S3, IAM, SNS, SQS (with a Dead Letter Queue), and EventBridge, while following security best practices (least privilege and blocking public access).
* Deploy the infrastructure to AWS and verify all resources through the AWS Management Console.
* Maintain effective collaboration with the team by discussing the daily work plan before starting and summarizing the results at the end of each day.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Set up the Terraform and HCP Terraform foundation: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Created the `terraform/` directory structure and wrote the `versions.tf` file to configure the AWS provider. <br>&emsp; + Configured HCP Terraform (`cloud {}` block) for remote state management. <br>&emsp; + Defined input variables in `variables.tf` (region, project_name, alert_email, and cost thresholds). <br>&emsp; + Summarized and shared the day's progress with the team. | 08/06/2026 | 08/06/2026 | - Terraform AWS Provider: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs <br> - HCP Terraform Docs: <br> https://developer.hashicorp.com/terraform/cloud-docs |
| Tue | - Deploy the storage and security layer (S3 + IAM): <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Wrote `s3.tf` to create the cost data bucket, enable Block Public Access, SSE-S3 encryption, versioning, and lifecycle rules for cost optimization. <br>&emsp; + Wrote `iam.tf` to create the Lambda IAM Role following the Principle of Least Privilege. <br>&emsp; + Summarized and shared the day's progress with the team. | 09/06/2026 | 09/06/2026 | - Amazon S3 User Guide: <br> https://docs.aws.amazon.com/AmazonS3/latest/userguide/ <br> - IAM Best Practices: <br> https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| Wed | - Deploy the notification and messaging layer (SNS + SQS): <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Wrote `sns.tf` to create the SNS topic and email subscription for alerts. <br>&emsp; + Wrote `sqs.tf` to create the main queue and a Dead Letter Queue (DLQ) with a redrive policy for error handling. <br>&emsp; + Summarized and shared the day's progress with the team. | 10/06/2026 | 10/06/2026 | - Amazon SNS Developer Guide: <br> https://docs.aws.amazon.com/sns/latest/dg/ <br> - Amazon SQS Developer Guide: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/ |
| Thu | - Deploy the scheduling component and provision the infrastructure: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Wrote `eventbridge.tf` to create a scheduled rule that runs once per day. <br>&emsp; + Wrote `outputs.tf` to export important values (ARNs and resource names). <br>&emsp; + Ran `terraform init`, `terraform plan`, and `terraform apply` to deploy the infrastructure to AWS. <br>&emsp; + Summarized and shared the day's progress with the team. | 11/06/2026 | 11/06/2026 | - Amazon EventBridge User Guide: <br> https://docs.aws.amazon.com/eventbridge/latest/userguide/ |
| Fri | - Verify the infrastructure on the AWS Management Console: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Verified S3 (Block Public Access, encryption, versioning), IAM (least privilege), SNS (email subscription confirmation), SQS (redrive policy to the DLQ), and EventBridge (rule and schedule). <br>&emsp; + Captured screenshots of the deployed resources for documentation purposes. <br>&emsp; + Summarized and shared the day's progress with the team. | 12/06/2026 | 12/06/2026 | - AWS Management Console. |

### Week 5 Achievements:

* **Successfully established the Infrastructure as Code foundation:** Built a complete Terraform project structure and configured HCP Terraform for remote state management. Using remote state centralizes infrastructure state storage, supports state locking, and provides a solid foundation for team collaboration and future project expansion.

* **Successfully deployed the core infrastructure following security best practices:** Defined and provisioned all essential infrastructure components, including S3 (cost data storage), IAM (access control), SNS (notifications), SQS and DLQ (event buffering and error handling), and EventBridge (scheduled execution). All resources follow AWS security best practices: the S3 bucket blocks public access and enables encryption, IAM Roles follow the Principle of Least Privilege, and no sensitive information is hard-coded.

* **Implemented a resilient error-handling mechanism:** Configured a Dead Letter Queue (DLQ) with a redrive policy for the SQS queue, ensuring that failed events are retained instead of being lost. This demonstrates a fault-tolerant system design approach.

* **Successfully deployed and verified the infrastructure:** Executed `terraform apply` successfully to provision the entire infrastructure on AWS. Verified each resource through the AWS Management Console to ensure the deployed configuration matched the design. Also confirmed the SNS email subscription so the system is ready to receive alerts. The infrastructure foundation is now fully prepared for developing the Lambda functions in the following weeks.

* **Team collaboration:** Maintained effective collaboration throughout the week. Before starting work each day, I discussed the daily plan with team members, and at the end of each day, I summarized the completed work so that everyone could stay updated on the project's progress.