---
title: "Worklog Week 7"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.7. </b> "
---

### Week 7 Objectives:

* Develop the Lambda Analyzer function, the cost analysis and alerting component of the CloudCost Insight system.
* Read cost data from S3 and implement logic to compare it against the budget threshold to detect cost overruns.
* Integrate Amazon SNS to send email notifications when costs exceed the defined threshold.
* Connect SQS to Lambda Analyzer (Event Source Mapping) for automatic event processing, using a dedicated IAM Role that follows the Principle of Least Privilege.
* Verify the end-to-end analysis and alerting workflow (SQS, Analyzer, S3, SNS, Email).
* Maintain effective team collaboration by discussing the daily plan before work and summarizing the results at the end of each day.

### Tasks Completed During the Week:

| Day | Task | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Design the analysis logic and implement the Analyzer: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Design the logic to read cost data from S3, calculate the total cost, and identify the top cost-consuming services. <br>&emsp; + Implement the logic to compare the total cost against the budget threshold. <br>&emsp; + Develop the Lambda Analyzer using Python and boto3. <br>&emsp; + Summarize the day's progress and share the results with the team. | 22/06/2026 | 22/06/2026 | - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html <br> - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| Tue | - Integrate SNS notifications: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Implement the function to send alerts via Amazon SNS when costs exceed the threshold. <br>&emsp; + Format the alert content (total cost, threshold, and top cost-consuming services). <br>&emsp; + Pass configuration values (BUCKET_NAME, SNS_TOPIC_ARN, COST_THRESHOLD_USD) through environment variables. <br>&emsp; + Summarize the day's progress and share the results with the team. | 23/06/2026 | 23/06/2026 | - Boto3 SNS Publish: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html <br> - Amazon SNS Developer Guide: <br> https://docs.aws.amazon.com/sns/latest/dg/ |
| Wed | - Write Terraform configuration to deploy the Analyzer and its dedicated IAM Role: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Create `lambda_analyzer.tf`: package the source code, create the Lambda function, and configure the CloudWatch Log Group with a retention policy. <br>&emsp; + Create a dedicated IAM Role for the Analyzer following the Principle of Least Privilege (read-only access to S3, receive messages from SQS, and publish to SNS). <br>&emsp; + Summarize the day's progress and share the results with the team. | 24/06/2026 | 24/06/2026 | - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function <br> - IAM Best Practices: <br> https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| Thu | - Connect SQS to Lambda (Event Source Mapping): <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Configure `aws_lambda_event_source_mapping` so that SQS automatically triggers the Analyzer. <br>&emsp; + Configure the batch size and connect the primary queue to the Analyzer function. <br>&emsp; + Run `terraform apply` to deploy the Analyzer to AWS. <br>&emsp; + Summarize the day's progress and share the results with the team. | 25/06/2026 | 25/06/2026 | - Terraform aws_lambda_event_source_mapping: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping <br> - Using Lambda with SQS: <br> https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html |
| Fri | - Test and verify the alerting workflow: <br>&emsp; + Discuss the daily work plan with the team before starting. <br>&emsp; + Temporarily set `threshold = -1` to validate the threshold detection logic independently of the Cost Explorer delay (the actual account cost is currently \$0). <br>&emsp; + Run the Collector to generate an event and verify that the Analyzer detects the threshold violation through CloudWatch Logs. <br>&emsp; + Confirm that the SNS email notification is successfully received. <br>&emsp; + Summarize the day's progress and share the results with the team. | 26/06/2026 | 26/06/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Amazon CloudWatch Logs. |

### Week 7 Achievements:

* **Completed the Analysis and Alerting Component (Analyzer):** Successfully developed the Lambda Analyzer using Python and boto3. The function can read cost data from S3, calculate the total cost, identify the top cost-consuming services, and compare the total cost against the configured budget threshold to detect cost overruns.

* **Integrated Automatic Email Alerts:** Successfully integrated Amazon SNS to send detailed email notifications whenever costs exceed the configured threshold. Each notification includes the total cost, the configured threshold, and the list of the most expensive AWS services, enabling users to quickly assess the situation and take appropriate action.

* **Implemented an Automated and Decoupled Architecture:** Configured Event Source Mapping so that SQS automatically triggers the Lambda Analyzer, completing the asynchronous workflow between the Collector and the Analyzer. This architecture improves flexibility, scalability, and overall system resilience.

* **Applied the Principle of Least Privilege:** Created a dedicated IAM Role for the Analyzer, separate from the Collector. The Analyzer was granted only the minimum permissions required (read access to S3, receive messages from SQS, and publish notifications to SNS), fully complying with AWS security best practices and strengthening the overall security of the system.

* **Verified the End-to-End Alerting Workflow:** Successfully validated the complete workflow by temporarily setting `threshold = -1`, allowing the threshold detection logic to be tested independently of the 24-hour delay of the Cost Explorer API (while the actual AWS account cost remained at \$0). The Analyzer correctly detected the threshold violation, generated detailed CloudWatch Logs, and successfully delivered the alert email through SNS, confirming that the entire analysis and alerting pipeline functioned correctly from end to end.

* **Team Collaboration:** Maintained effective collaboration throughout the week. Before starting work each day, I discussed the daily plan with my teammates, and at the end of each day, I summarized the completed tasks to keep everyone informed of the project's progress.