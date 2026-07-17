---
title: "Week 8 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.8. </b> "
---

### Week 8 Objectives:

* Enhance the analysis logic of the Lambda Analyzer by adding anomaly detection based on historical averages (spike detection), rather than relying solely on a fixed threshold.
* Classify alerts into three severity levels: INFO / WARNING / CRITICAL.
* Improve the Amazon SNS alert message by including the alert severity, reason, and percentage increase.
* Verify the error-handling mechanism (Dead Letter Queue) to ensure the system is resilient.
* Perform an end-to-end test of the entire system by triggering only the Collector and allowing the complete workflow to run automatically through to alert notification.

### Tasks Completed During the Week:

| Day | Tasks | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Enhance the anomaly detection logic: <br>&emsp; + Implement a function to read historical cost data from Amazon S3 and calculate the average cost. <br>&emsp; + Add spike detection logic (current cost > historical average × multiplier). <br>&emsp; + Introduce two new configuration variables: `SPIKE_MULTIPLIER` and `HISTORY_DAYS`. | 29/06/2026 | 29/06/2026 | - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| Tue | - Classify alert severity and improve Amazon SNS notifications: <br>&emsp; + Implement the logic to classify alerts into INFO / WARNING / CRITICAL based on the configured threshold and the magnitude of the cost spike. <br>&emsp; + Update the email notification to include the alert severity, alert reason, percentage increase, and historical average cost. <br>&emsp; + Standardize the currency display format as ($X.XX). | 30/06/2026 | 30/06/2026 | |
| Wed | - Update Terraform, test the three alert levels, and verify error handling (DLQ): <br>&emsp; + Add the `spike_multiplier` and `history_days` variables and deploy the upgraded Analyzer code. <br>&emsp; + Create a script to generate simulated cost data and test the INFO / WARNING / CRITICAL scenarios. <br>&emsp; + Test the DLQ by sending an invalid message and verifying that it is automatically moved to the Dead Letter Queue. | 01/07/2026 | 01/07/2026 | - Amazon SQS Dead-Letter Queues: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html <br> - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function |
| Thu | - Perform an end-to-end test of the entire system: <br>&emsp; + Prepare simulated cost data (historical data and test-day data) in Amazon S3 for the WARNING and CRITICAL scenarios. <br>&emsp; + Trigger only the Lambda Collector and allow the system to automatically process events through Amazon SQS → Lambda Analyzer without manual intervention. <br>&emsp; + Monitor the complete automated workflow: Collector → Amazon S3 → Amazon SQS → Analyzer → Amazon SNS. | 02/07/2026 | 02/07/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Using Lambda with SQS: <br> https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html |
| Fri | - Verify the results and fine-tune the system: <br>&emsp; + Confirm that the WARNING and CRITICAL notification emails are received correctly with the standardized currency format ($X.XX). <br>&emsp; + Review Amazon CloudWatch Logs to verify correct alert classification. <br>&emsp; + Restore the threshold to its production value and clean up the test data. | 03/07/2026 | 03/07/2026 | |

### Week 8 Achievements:

* **Enhanced the intelligent anomaly detection logic:** Successfully upgraded the Analyzer to support two detection criteria: (1) comparison against a fixed budget threshold, and (2) spike detection based on the historical average cost calculated from previous days' data stored in Amazon S3. This is a significant improvement that enables the system to detect unusual cost increases even when the absolute threshold has not yet been exceeded—similar to the approach used by AWS Cost Anomaly Detection, but implemented entirely within the project.

* **Implemented multi-level alert classification:** Successfully implemented a three-level alert classification mechanism: INFO / WARNING / CRITICAL. The email notification was enhanced to include the alert severity, a detailed reason, the percentage increase, and the historical average cost. In addition, the currency display format was standardized to improve readability and presentation.

* **Successfully tested all three alert scenarios:** Created simulated cost datasets and successfully validated all three scenarios: INFO (normal cost, no notification), WARNING (budget threshold exceeded), and CRITICAL (significant spike compared to the historical average). The classification results were accurately recorded in Amazon CloudWatch Logs, and email notifications were successfully delivered for both the WARNING and CRITICAL levels.

* **Verified the fault-tolerance mechanism (DLQ):** Successfully tested the error-handling workflow by sending an invalid message that referenced a non-existent object. The message was retried according to the configured retry policy and automatically moved to the Dead Letter Queue after exceeding the maximum retry attempts, ensuring that the system neither loses data nor enters an infinite retry loop when failures occur.

* **Successfully completed end-to-end system testing:** Successfully validated the entire automated workflow: by triggering only the Lambda Collector, the system automatically executed the complete pipeline through Amazon S3 → Amazon SQS → Lambda Analyzer → Amazon SNS without any manual intervention. The results confirmed that all components were correctly integrated, the system accurately detected both WARNING and CRITICAL conditions, and notification emails were successfully delivered, demonstrating that CloudCost Insight operates reliably as a fully integrated, end-to-end automated system.