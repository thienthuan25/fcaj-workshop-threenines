---
title: "Week 6 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.6. </b> "
---

### Week 6 Objectives:

* Develop the Lambda Collector function, the data collection component of the CloudCost Insight system.
* Integrate the AWS Cost Explorer API to retrieve daily AWS service cost data.
* Store cost data in S3 (partitioned by date) and send events to SQS for the analysis stage.
* Deploy the Lambda function using Terraform and connect it to EventBridge to automate scheduled data collection.
* Verify the end-to-end data collection workflow (Lambda, Cost Explorer, S3, and SQS).
* Maintain effective collaboration with the team by discussing the daily work plan before starting and summarizing the results at the end of each day.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Research the Cost Explorer API and design the Lambda function: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Studied the `GetCostAndUsage` API and its parameters: TimePeriod, Granularity, Metrics, and GroupBy. <br>&emsp; + Determined that the system should retrieve the previous day's cost data because Cost Explorer has a data latency of up to 24 hours. <br>&emsp; + Designed the data structure and S3 partitioning strategy. <br>&emsp; + Summarized and shared the day's progress with the team. | 15/06/2026 | 15/06/2026 | - AWS Cost Explorer API (GetCostAndUsage): <br> https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_GetCostAndUsage.html |
| Tue | - Develop the Lambda Collector (Python + boto3): <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Implemented the function to call the Cost Explorer API and retrieve cost data by AWS service. <br>&emsp; + Implemented the function to store cost data as JSON files in S3 (partitioned by year/month/day). <br>&emsp; + Implemented the function to send events (total cost and S3 object key) to SQS. <br>&emsp; + Summarized and shared the day's progress with the team. | 16/06/2026 | 16/06/2026 | - Boto3 Cost Explorer Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ce.html <br> - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html |
| Wed | - Write Terraform configuration to deploy the Lambda function: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Wrote `lambda_collector.tf` to package the source code (`archive_file`), create the Lambda function, and configure a CloudWatch Log Group with a retention policy. <br>&emsp; + Passed configuration values through environment variables (`BUCKET_NAME`, `QUEUE_URL`) instead of hard-coding them. <br>&emsp; + Summarized and shared the day's progress with the team. | 17/06/2026 | 17/06/2026 | - Terraform `aws_lambda_function`: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function <br> - Terraform `archive_file`: <br> https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file |
| Thu | - Connect EventBridge and update IAM permissions: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Updated `eventbridge.tf` to connect the scheduled rule to the Lambda function (target + `lambda_permission`). <br>&emsp; + Added the `sqs:SendMessage` permission to the Collector IAM Role while maintaining the Principle of Least Privilege. <br>&emsp; + Ran `terraform apply` to deploy the Lambda function to AWS. <br>&emsp; + Summarized and shared the day's progress with the team. | 18/06/2026 | 18/06/2026 | - Terraform `aws_cloudwatch_event_target`: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target <br> - EventBridge with Lambda: <br> https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-use-resource-based.html |
| Fri | - Test and verify the data collection workflow: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Manually tested the Lambda Collector using an empty test event in the AWS Console. <br>&emsp; + Checked CloudWatch Logs to verify that the Lambda function executed successfully. <br>&emsp; + Confirmed that the cost data was written to S3 and that the event was successfully sent to SQS. <br>&emsp; + Summarized and shared the day's progress with the team. | 19/06/2026 | 19/06/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Amazon CloudWatch Logs. |

### Week 6 Achievements:

* **Completed the data collection component (Collector):** Successfully developed the Lambda Collector function using Python and boto3, integrating it directly with the AWS Cost Explorer API to automatically retrieve daily AWS service cost data. This is the first component in the CloudCost Insight data pipeline.
* **Designed an efficient storage structure:** Cost data is stored in S3 as JSON files and partitioned by the `year/month/day` directory structure, making future querying and visualization in the dashboard more efficient and scalable.
* **Implemented automation and decoupling:** Deployed the Lambda function using Terraform and connected it to EventBridge, allowing the system to collect cost data automatically on a scheduled basis without manual intervention. The Collector publishes events to SQS, decoupling the data collection and analysis stages to improve the system's flexibility and resilience.
* **Followed security best practices and dynamic configuration:** Added the `sqs:SendMessage` permission to the IAM Role while adhering to the Principle of Least Privilege. All configuration values, including the S3 bucket name and SQS queue URL, are provided through environment variables instead of being hard-coded, following AWS security best practices.
* **Verified the end-to-end data collection workflow:** Successfully tested the Lambda function in the AWS Console and confirmed that the complete workflow operates correctly—from retrieving cost data through the Cost Explorer API, storing it in S3, to publishing events to SQS. CloudWatch Logs recorded all execution details, confirming that the Collector component is fully functional and ready for integration with the Lambda Analyzer in the following week.
* **Team collaboration:** Maintained effective collaboration throughout the week. Before starting work each day, I discussed the daily plan with team members, and at the end of each day, I summarized the completed work so that everyone could stay updated on the project's progress.