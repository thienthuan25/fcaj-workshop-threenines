---
title: "Week 9 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.9. </b> "
---

### Week 9 Objectives:

* Add CloudWatch Alarms to monitor system failures, including alerts for Lambda execution errors and messages sent to the Dead Letter Queue (DLQ).
* Successfully verify the Alarm -> Amazon SNS -> Email notification workflow.
* Update the system architecture diagram by replacing the Athena + QuickSight approach with a custom web dashboard architecture (Lambda API, API Gateway, CloudFront + Amazon S3 Static Website Hosting).
* Develop the backend for the dashboard by implementing the Lambda API, creating an API Gateway, and successfully testing the API.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Add CloudWatch Alarms for Lambda error monitoring: <br>&emsp; + Configure CloudWatch Alarms to monitor the `Errors` metric of both the Lambda Collector and Lambda Analyzer. <br>&emsp; + Attach an Amazon SNS notification action when an alarm is triggered. <br>&emsp; + Deploy the alarms using Terraform (`aws_cloudwatch_metric_alarm`). | 06/07/2026 | 06/07/2026 | - Terraform aws_cloudwatch_metric_alarm: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm <br> - Using CloudWatch Alarms: <br> https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html |
| Tue | - Add a CloudWatch Alarm for the DLQ and verify the alarm workflow: <br>&emsp; + Configure an alarm to monitor the `ApproximateNumberOfMessagesVisible` metric of the Dead Letter Queue. <br>&emsp; + Send an invalid message to trigger the alarm and successfully verify the Alarm -> Amazon SNS -> Email workflow. <br>&emsp; + Confirm that the incident notification email is received with complete information. | 07/07/2026 | 07/07/2026 | - Amazon SQS CloudWatch Metrics: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-monitoring-using-cloudwatch.html |
| Wed | - Update the architecture diagram (new dashboard approach): <br>&emsp; + Remove Athena and QuickSight from the architecture. <br>&emsp; + Introduce the custom web dashboard architecture consisting of Lambda API, API Gateway, CloudFront, and Amazon S3 Static Website Hosting. <br>&emsp; + Redraw the workflow: User -> CloudFront/Amazon S3 (load the web interface) and User -> API Gateway -> Lambda API -> Amazon S3 (retrieve cost data). | 08/07/2026 | 08/07/2026 | - AWS Architecture Icons and diagramming tools (draw.io). |
| Thu | - Develop the Lambda API (backend data service): <br>&emsp; + Implement the Lambda API function (Python) to read and aggregate cost data from Amazon S3 (total cost, daily costs with status, and top-cost AWS services). <br>&emsp; + Return the response as JSON with CORS headers so that the web frontend can access the API. <br>&emsp; + Apply a dedicated IAM Role following the Principle of Least Privilege (read-only access to Amazon S3 and permission to write logs only). | 09/07/2026 | 09/07/2026 | - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html <br> - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| Fri | - Create the API Gateway and test the API: <br>&emsp; + Create an HTTP API Gateway with the `GET /costs` route and enable CORS. <br>&emsp; + Grant API Gateway permission to invoke the Lambda function (`aws_lambda_permission`). <br>&emsp; + Successfully test the API by accessing the endpoint from a web browser and verifying that it returns the expected JSON response. | 10/07/2026 | 10/07/2026 | - Amazon API Gateway (HTTP API): <br> https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html <br> - Terraform aws_apigatewayv2_api: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api |

### Week 9 Achievements:

* **Added system failure monitoring with CloudWatch Alarms:** Successfully configured CloudWatch Alarms to monitor the health of the system. Alerts are triggered when the Lambda Collector or Lambda Analyzer encounters execution errors (using the `Errors` metric) and when messages are moved to the Dead Letter Queue. All alarms publish notifications through Amazon SNS, allowing operators to be immediately informed of system failures and ensuring reliable system monitoring.

* **Successfully verified the incident notification workflow:** Successfully tested the Alarm -> Amazon SNS -> Email workflow by sending an invalid message to trigger the alarm. Confirmed that the notification email contained complete information, including the alarm name, reason, monitored metric, and timestamp. An important observation was also confirmed: CloudWatch Alarms send notifications only when the alarm changes state (OK -> ALARM), rather than repeatedly while remaining in the ALARM state.

* **Updated the architecture toward a custom web dashboard:** Replaced the Athena + QuickSight approach (managed services with additional costs) with a **custom-built web dashboard** architecture consisting of Lambda API + API Gateway for the backend and CloudFront + Amazon S3 Static Website Hosting for the frontend. The updated architecture clearly illustrates two separate workflows: loading the web interface and retrieving data through the API, establishing the foundation for CloudCost Insight as a fully self-managed product.

* **Implemented the backend data service (Lambda API):** Successfully developed the Lambda API function to read and aggregate cost data from Amazon S3, including the total cost, daily costs with status, and the highest-cost AWS services. The function returns JSON responses with CORS headers, enabling seamless communication with the frontend. It uses a dedicated IAM Role that follows the Principle of Least Privilege, granting only read access to Amazon S3 and permission to write logs.

* **Created and successfully tested the API Gateway:** Successfully created an HTTP API Gateway with the `GET /costs` route and enabled CORS support. Granted API Gateway permission to invoke the Lambda function and successfully tested the endpoint by accessing it directly from a web browser, receiving the expected JSON response. This confirms that the backend layer of the web dashboard is fully operational and ready for frontend development in the following week.