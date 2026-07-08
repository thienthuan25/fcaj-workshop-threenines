---
title: "Week 6 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.6. </b> "
---

### Week 6 Objectives:

* Develop the Lambda Collector function—the component responsible for collecting cost data for the CloudCost Insight system.
* Integrate the AWS Cost Explorer API to retrieve daily AWS service cost data.
* Store cost data in Amazon S3 (partitioned by date) and send events to Amazon SQS for the analysis stage.
* Deploy the Lambda function using Terraform and connect it with Amazon EventBridge to automate periodic data collection.
* Verify the end-to-end data collection workflow (Lambda → Cost Explorer → Amazon S3 → Amazon SQS).

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Research the Cost Explorer API and design the Lambda function: <br>&emsp; + Study the `GetCostAndUsage` API, including the TimePeriod, Granularity, Metrics, and GroupBy parameters. <br>&emsp; + Determine that the function should retrieve the previous day's cost data (since Cost Explorer data may be delayed by up to 24 hours). <br>&emsp; + Design the data structure and the storage partitioning strategy in Amazon S3. | 15/06/2026 | 15/06/2026 | - AWS Cost Explorer API (GetCostAndUsage): <br> https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_GetCostAndUsage.html |
| Tue | - Develop the Lambda Collector (Python + boto3): <br>&emsp; + Implement the function to call the Cost Explorer API and retrieve costs grouped by AWS service. <br>&emsp; + Implement the function to store JSON data in Amazon S3 (partitioned by year/month/day). <br>&emsp; + Implement the function to send an event (total cost and S3 object key) to Amazon SQS. | 16/06/2026 | 16/06/2026 | - Boto3 Cost Explorer Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ce.html <br> - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html |
| Wed | - Write Terraform configuration for Lambda deployment: <br>&emsp; + Create `lambda_collector.tf`: package the source code (`archive_file`), create the Lambda function, and configure the CloudWatch Log Group with log retention. <br>&emsp; + Pass configuration values through environment variables (`BUCKET_NAME`, `QUEUE_URL`) instead of hard-coding them. | 17/06/2026 | 17/06/2026 | - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function <br> - Terraform archive_file: <br> https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file |
| Thu | - Connect EventBridge and update IAM permissions: <br>&emsp; + Update `eventbridge.tf` to connect the scheduled rule to the Lambda function (target + `lambda_permission`). <br>&emsp; + Add the `sqs:SendMessage` permission to the Collector IAM Role while maintaining the Principle of Least Privilege. <br>&emsp; + Run `terraform apply` to deploy the Lambda function to AWS. | 18/06/2026 | 18/06/2026 | - Terraform aws_cloudwatch_event_target: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target <br> - EventBridge with Lambda: <br> https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-use-resource-based.html |
| Fri | - Test and verify the data collection workflow: <br>&emsp; + Manually test the Lambda Collector in the AWS Console using an empty test event. <br>&emsp; + Check Amazon CloudWatch Logs to confirm that the Lambda function executed successfully. <br>&emsp; + Verify that the cost data was stored in Amazon S3 and that the event was successfully sent to Amazon SQS. | 19/06/2026 | 19/06/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Amazon CloudWatch Logs. |

### Week 6 Achievements:

* **Completed the data collection component (Collector):** Successfully developed the Lambda Collector function using Python and boto3, integrating directly with the AWS Cost Explorer API to automatically retrieve daily AWS service cost data. This serves as the first component in the data pipeline of the CloudCost Insight system.

* **Designed an efficient storage structure:** Cost data is stored in Amazon S3 as JSON files and partitioned using the `year/month/day` structure, making future querying and dashboard visualization more efficient and organized.

* **Implemented automation and decoupling:** Deployed the Lambda function using Terraform and integrated it with Amazon EventBridge, enabling the system to automatically collect cost data on a scheduled basis without manual intervention. The Collector sends events to Amazon SQS, decoupling the data collection process from the analysis stage, thereby improving the system's flexibility and resilience.

* **Followed security best practices and dynamic configuration:** Added the `sqs:SendMessage` permission to the Collector IAM Role while adhering to the Principle of Least Privilege. All configuration values, including the S3 bucket name and queue URL, are provided through environment variables instead of being hard-coded, following AWS security best practices.

* **Verified the end-to-end data collection workflow:** Successfully tested the Lambda function in the AWS Management Console and confirmed that the entire workflow operates as expected: Lambda invokes the Cost Explorer API → stores the cost data in Amazon S3 → sends an event to Amazon SQS. Amazon CloudWatch Logs recorded the complete execution process, confirming that the Collector component is ready to integrate with the Lambda Analyzer in the following week.