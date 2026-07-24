---
title: "Week 9 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.9. </b> "
---

### Week 9 Objectives:

* Add CloudWatch Alarms to monitor system failures: trigger alerts when Lambda functions encounter errors or when messages are sent to the Dead Letter Queue (DLQ).
* Successfully test the Alarm, SNS, and Email notification mechanism.
* Update the architecture diagram by replacing the Athena + QuickSight approach with a custom web dashboard architecture (Lambda API, API Gateway, CloudFront + S3 Web Hosting).
* Develop the backend for the dashboard: implement the Lambda API, create the API Gateway, and successfully test the API.
* Continue effective collaboration with the team by discussing the daily plan before work and summarizing progress at the end of each day.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | References |
| --- | --- | --- | --- | --- |
| Mon | - Add CloudWatch Alarms for Lambda error monitoring: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Configure CloudWatch Alarms to monitor the `Errors` metric for both the Collector and Analyzer Lambda functions. <br>&emsp; + Attach SNS notification actions when an alarm is triggered. <br>&emsp; + Deploy using Terraform (`aws_cloudwatch_metric_alarm`). <br>&emsp; + Summarize and share the day's progress with the team. | 06/07/2026 | 06/07/2026 | - Terraform aws_cloudwatch_metric_alarm: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm <br> - Using CloudWatch Alarms: <br> https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html |
| Tue | - Add a DLQ Alarm and test the alarm mechanism: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Configure an Alarm to monitor the `ApproximateNumberOfMessagesVisible` metric of the Dead Letter Queue. <br>&emsp; + Send a failed message to trigger the Alarm and successfully test the Alarm, SNS, and Email notification flow. <br>&emsp; + Verify that the incident alert email is received with complete information. <br>&emsp; + Summarize and share the day's progress with the team. | 07/07/2026 | 07/07/2026 | - Amazon SQS CloudWatch Metrics: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-monitoring-using-cloudwatch.html |
| Wed | - Update the architecture diagram (dashboard redesign): <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Remove Athena and QuickSight from the architecture diagram. <br>&emsp; + Introduce the custom web dashboard architecture: Lambda API, API Gateway, CloudFront, and S3 Web Hosting. <br>&emsp; + Redraw the architecture flow: User → CloudFront/S3 (load the web interface) and User → API Gateway → Lambda API → S3 (retrieve data). <br>&emsp; + Summarize and share the day's progress with the team. | 08/07/2026 | 08/07/2026 | - AWS Architecture Icons & diagramming tool (draw.io). |
| Thu | - Develop the Lambda API (backend data provider): <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Develop the Lambda API (Python) to read and aggregate cost data from S3 (total cost, daily cost with status, top-cost services). <br>&emsp; + Return JSON responses with CORS headers so the web frontend can access the API. <br>&emsp; + Apply a dedicated IAM Role following the Least Privilege principle (read-only access to S3 and permission to write logs). <br>&emsp; + Summarize and share the day's progress with the team. | 09/07/2026 | 09/07/2026 | - AWS Lambda Developer Guide (Python): <br> https://docs.aws.amazon.com/lambda/latest/dg/lambda-python.html <br> - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| Fri | - Create the API Gateway and test the API: <br>&emsp; + Discuss the day's work plan with the team before starting. <br>&emsp; + Create an HTTP API Gateway with the `GET /costs` route and enable CORS. <br>&emsp; + Grant API Gateway permission to invoke the Lambda function (`aws_lambda_permission`). <br>&emsp; + Successfully test the API by accessing the endpoint directly from a web browser and verifying that it returns correctly structured JSON data. <br>&emsp; + Summarize and share the day's progress with the team. | 10/07/2026 | 10/07/2026 | - Amazon API Gateway (HTTP API): <br> https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html <br> - Terraform aws_apigatewayv2_api: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api |

### Week 9 Achievements:

* **Added CloudWatch Alarms for system failure monitoring:** Configured CloudWatch Alarms to monitor the health of the system by detecting errors in the Collector and Analyzer Lambda functions (using the `Errors` metric) and monitoring messages that arrive in the Dead Letter Queue. These Alarms send notifications through Amazon SNS, allowing operators to be alerted immediately whenever the system encounters an issue and ensuring reliable monitoring.

* **Successfully tested the incident alerting mechanism:** Successfully verified the complete Alarm → SNS → Email notification workflow by intentionally sending a failed message to trigger an Alarm. Confirmed that the alert email contained all essential information, including the Alarm name, reason, metric, and timestamp. During testing, an important behavior of CloudWatch Alarms was also observed: notifications are sent only when the alarm **changes state** (from **OK** to **ALARM**), and are not repeatedly sent while the alarm remains in the **ALARM** state.

* **Updated the architecture diagram for a custom web dashboard:** Replaced the Athena + QuickSight approach (managed services with additional cost) with a **custom-built web dashboard** architecture consisting of a Lambda API and API Gateway for the backend, along with CloudFront and S3 Web Hosting for the frontend. The updated diagram clearly illustrates the two separate flows: loading the web interface and retrieving data through the API, moving CloudCost Insight closer to becoming a fully self-managed product.

* **Implemented the backend data service (Lambda API):** Successfully developed the Lambda API to read and aggregate cost data from S3, including total cost, daily costs with status information, and the top cost-consuming AWS services. The function returns JSON responses with CORS headers so that the frontend can consume the API directly. A dedicated IAM Role was applied following the Least Privilege principle, granting only S3 read permissions and CloudWatch logging permissions.

* **Created and successfully tested the API Gateway:** Created an HTTP API Gateway with the `GET /costs` endpoint and enabled CORS. Granted API Gateway permission to invoke the Lambda API and successfully tested the endpoint directly from a web browser. The API returned correctly structured JSON data, confirming that the backend layer of the web dashboard was fully operational and ready for frontend development in the following week.

* **Team collaboration:** Maintained an effective teamwork routine throughout the week. Before starting work each day, I discussed the daily plan with my teammates, and at the end of each day, I summarized the completed work so that everyone could stay updated on the project's progress.