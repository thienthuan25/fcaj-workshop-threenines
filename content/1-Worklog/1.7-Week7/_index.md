---
title: "Week 7 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.7. </b> "
---

### Week 7 Objectives:

* Develop the Lambda Analyzer function—the component responsible for cost analysis and alerting in the CloudCost Insight system.
* Read cost data from Amazon S3 and implement the logic to compare it against budget thresholds to detect cost overruns.
* Integrate Amazon SNS to send email notifications when costs exceed the defined threshold.
* Connect Amazon SQS to the Lambda Analyzer (Event Source Mapping) for automatic event processing, using a dedicated IAM Role that follows the Principle of Least Privilege.
* Verify the end-to-end analysis and alerting workflow (Amazon SQS → Lambda Analyzer → Amazon S3 → Amazon SNS → Email).

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Design the analysis logic and develop the Analyzer: <br>&emsp; + Design the logic to read cost data from Amazon S3, calculate the total cost, and identify the highest-cost AWS services. <br>&emsp; + Implement the logic to compare the total cost against the configured budget threshold. <br>&emsp; + Develop the Lambda Analyzer function using Python and boto3. | 22/06/2026 | 22/06/2026 | - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html <br> - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| Tue | - Integrate Amazon SNS for notifications: <br>&emsp; + Implement the function to publish alert messages through Amazon SNS when the cost exceeds the configured threshold. <br>&emsp; + Format the alert message to include the total cost, threshold value, and the highest-cost services. <br>&emsp; + Pass configuration values (`BUCKET_NAME`, `SNS_TOPIC_ARN`, and `COST_THRESHOLD_USD`) through environment variables. | 23/06/2026 | 23/06/2026 | - Boto3 SNS Publish: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/sns.html <br> - Amazon SNS Developer Guide: <br> https://docs.aws.amazon.com/sns/latest/dg/ |
| Wed | - Write Terraform configuration to deploy the Analyzer and create a dedicated IAM Role: <br>&emsp; + Create `lambda_analyzer.tf` to package the source code, deploy the Lambda function, and configure the CloudWatch Log Group with log retention. <br>&emsp; + Create a dedicated IAM Role for the Analyzer following the Principle of Least Privilege (read access to Amazon S3, receive messages from Amazon SQS, and publish messages to Amazon SNS only). | 24/06/2026 | 24/06/2026 | - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function <br> - IAM Best Practices: <br> https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| Thu | - Connect Amazon SQS to Lambda (Event Source Mapping): <br>&emsp; + Configure `aws_lambda_event_source_mapping` so that Amazon SQS automatically triggers the Lambda Analyzer. <br>&emsp; + Configure the batch size and connect the primary queue to the Analyzer function. <br>&emsp; + Run `terraform apply` to deploy the Analyzer to AWS. | 25/06/2026 | 25/06/2026 | - Terraform aws_lambda_event_source_mapping: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping <br> - Using Lambda with SQS: <br> https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html |
| Fri | - Test and verify the alerting workflow: <br>&emsp; + Temporarily set `threshold = -1` to test the threshold detection logic independently of the Cost Explorer data delay (the actual account cost was \$0). <br>&emsp; + Execute the Collector to generate an event and verify that the Analyzer detects the threshold breach through Amazon CloudWatch Logs. <br>&emsp; + Confirm that the alert email is successfully delivered through Amazon SNS. | 26/06/2026 | 26/06/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Amazon CloudWatch Logs. |

### Week 7 Achievements:

* **Completed the analysis and alerting component (Analyzer):** Successfully developed the Lambda Analyzer function using Python and boto3. The function can read cost data from Amazon S3, calculate the total cost, identify the highest-cost AWS services, and compare the total cost against the configured budget threshold to detect cost overruns. This component serves as the analytical "brain" of the CloudCost Insight system.

* **Integrated automated email notifications:** Successfully integrated Amazon SNS to send detailed email notifications whenever the cost exceeds the configured threshold. Each notification includes the total cost, the configured threshold, and a list of the highest-cost AWS services, enabling users to quickly understand the situation and respond promptly.

* **Implemented an automated and decoupled architecture:** Configured Event Source Mapping so that Amazon SQS automatically triggers the Lambda Analyzer, completing the asynchronous processing workflow between the data collection stage (Collector) and the analysis stage (Analyzer). This architecture improves the system's flexibility, scalability, and ability to handle higher workloads.

* **Applied the Principle of Least Privilege:** Created a dedicated IAM Role for the Analyzer, completely separated from the Collector's IAM Role. The Analyzer is granted only the minimum permissions required—reading from Amazon S3, receiving messages from Amazon SQS, and publishing notifications to Amazon SNS—strictly following AWS security best practices and reinforcing the system's secure design.

* **Verified the end-to-end alerting workflow:** Successfully tested the complete workflow by temporarily setting the alert threshold to `threshold = -1`, allowing the threshold detection logic to be verified independently of the 24-hour delay of the Cost Explorer API (while the actual AWS account cost remained at \$0). As a result, the Analyzer correctly detected the threshold breach, recorded detailed execution logs in Amazon CloudWatch Logs, and successfully delivered an alert email through Amazon SNS, confirming that the entire analysis and alerting workflow operates correctly from end to end.