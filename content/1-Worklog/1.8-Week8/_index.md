---
title: "Week 8 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.8. </b> "
---

### Week 8 Objectives:

* Enhance the analysis logic of the Lambda Analyzer by adding anomaly detection based on historical averages (spike detection), instead of relying solely on a fixed threshold.
* Classify alerts into three severity levels: INFO / WARNING / CRITICAL.
* Improve the Amazon SNS alert message by including the alert severity, reason, and spike percentage.
* Fully test all three alert scenarios (INFO, WARNING, and CRITICAL) using simulated data.
* Verify the error-handling mechanism (Dead Letter Queue) to ensure the system is resilient.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Enhance the anomaly detection logic: <br>&emsp; + Implement a function to read historical cost data from Amazon S3 and calculate the average cost. <br>&emsp; + Add spike detection logic (current cost > historical average × multiplier). <br>&emsp; + Introduce two new configuration variables: `SPIKE_MULTIPLIER` and `HISTORY_DAYS`. | 29/06/2026 | 29/06/2026 | - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| Tue | - Classify alert severity and improve Amazon SNS notifications: <br>&emsp; + Implement the logic to classify alerts into INFO / WARNING / CRITICAL based on the configured threshold and the magnitude of the cost spike. <br>&emsp; + Update the email notification to include the alert severity, reason, spike percentage, and historical average cost. | 30/06/2026 | 30/06/2026 | |
| Wed | - Update Terraform configuration and deploy the new version: <br>&emsp; + Add the `spike_multiplier` and `history_days` variables to `variables.tf` and pass them to the Lambda function through environment variables. <br>&emsp; + Run `terraform apply` to deploy the upgraded version of the Analyzer. | 01/07/2026 | 01/07/2026 | - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function |
| Thu | - Test the INFO / WARNING / CRITICAL scenarios: <br>&emsp; + Create a script to generate simulated cost data (historical data and test-day data) and upload it to Amazon S3. <br>&emsp; + Execute each test scenario and verify the classification results through Amazon CloudWatch Logs. <br>&emsp; + Confirm that email notifications are delivered correctly for the WARNING and CRITICAL levels. | 02/07/2026 | 02/07/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Amazon CloudWatch Logs. |
| Fri | - Test the error-handling mechanism (DLQ): <br>&emsp; + Send an invalid message (referencing a non-existent S3 object) to the Amazon SQS queue. <br>&emsp; + Verify that the Analyzer fails to process the message, retries it according to the configured policy, and automatically moves it to the Dead Letter Queue. <br>&emsp; + Add the `s3:ListBucket` permission to provide clearer error messages. | 03/07/2026 | 03/07/2026 | - Amazon SQS Dead-Letter Queues: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html |

### Week 8 Achievements:

* **Enhanced the anomaly detection logic:** Successfully upgraded the Analyzer to support two detection criteria: (1) comparison against a fixed budget threshold, and (2) spike detection based on the historical average cost calculated from previous days' data stored in Amazon S3. This is a significant improvement, enabling the system to detect unusual cost increases even when the absolute budget threshold has not yet been exceeded—similar to the approach used by AWS Cost Anomaly Detection, but implemented entirely within the project.

* **Implemented multi-level alert classification:** Successfully implemented a three-level alert classification mechanism: INFO / WARNING / CRITICAL. The email notification was enhanced to include the alert severity, a detailed reason, the spike percentage, and the historical average cost, allowing users to quickly assess the seriousness of the situation.

* **Enabled flexible configuration through variables:** Added the `spike_multiplier` (spike detection sensitivity) and `history_days` (number of days used to calculate the historical average) configuration variables. These parameters allow the anomaly detection behavior to be customized without modifying the source code, with all configuration managed centrally through HCP Terraform.

* **Successfully tested all three alert scenarios:** Created simulated cost datasets and successfully validated all three scenarios: INFO (normal cost, no notification), WARNING (budget threshold exceeded), and CRITICAL (significant spike compared to the historical average). The classification results were accurately recorded in Amazon CloudWatch Logs, and email notifications were successfully delivered for both the WARNING and CRITICAL levels.

* **Verified the fault-tolerance mechanism (DLQ):** Successfully tested the error-handling workflow by sending an invalid message that referenced a non-existent Amazon S3 object. The message was retried according to the configured retry policy and automatically moved to the Dead Letter Queue after exceeding the maximum retry attempts, ensuring that the system neither loses data nor enters an infinite retry loop. Additionally, the `s3:ListBucket` permission was added so that the system can return clearer and more accurate error messages.