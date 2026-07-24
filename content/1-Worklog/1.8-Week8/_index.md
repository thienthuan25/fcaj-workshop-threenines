---
title: "Worklog Week 8"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.8. </b> "
---

### Week 8 Objectives:

* Enhance the Lambda Analyzer by adding anomaly detection based on historical averages (spike detection), rather than relying solely on a fixed threshold.
* Classify alerts into three severity levels: INFO / WARNING / CRITICAL.
* Finalize the SNS notification content, including the alert severity, reason, and percentage increase.
* Verify the fault-tolerance mechanism using a Dead Letter Queue (DLQ) to ensure system resilience.
* Perform end-to-end testing of the entire system by triggering only the Collector and allowing the entire workflow to execute automatically until notifications are sent.
* Maintain effective team collaboration by discussing the daily plan before work and summarizing the results at the end of each day.

### Tasks Completed During the Week:

| Day | Task | Start Date | Completion Date | Reference Materials |
| --- | --- | --- | --- | --- |
| Mon | - Worked on-site at the office. <br>&emsp; + Discussed the daily work plan with the team before starting. <br> - Enhanced the anomaly detection logic: <br>&emsp; + Implemented a function to read historical cost data from S3 and calculate the average cost. <br>&emsp; + Added spike detection logic (cost > average × multiplier). <br>&emsp; + Introduced two new configuration variables: `SPIKE_MULTIPLIER` and `HISTORY_DAYS`. <br>&emsp; + Summarized the day's progress and shared the results with the team. | 29/06/2026 | 29/06/2026 | - Boto3 S3 Client: <br> https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html |
| Tue | - Implemented alert classification and finalized SNS notifications: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Implemented the INFO / WARNING / CRITICAL classification logic based on both the budget threshold and spike detection. <br>&emsp; + Updated the email notification content to include the alert severity, reason, percentage increase, and historical average. <br>&emsp; + Standardized the currency format ($X.XX). <br>&emsp; + Summarized the day's progress and shared the results with the team. | 30/06/2026 | 30/06/2026 | |
| Wed | - Updated Terraform, tested all three alert levels, and verified the DLQ mechanism: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Added the `spike_multiplier` and `history_days` variables and deployed the enhanced Analyzer code. <br>&emsp; + Created a script to generate simulated cost data and tested the INFO / WARNING / CRITICAL scenarios. <br>&emsp; + Tested the DLQ by sending an invalid message and verified that it was automatically moved to the Dead Letter Queue. <br>&emsp; + Summarized the day's progress and shared the results with the team. | 01/07/2026 | 01/07/2026 | - Amazon SQS Dead-Letter Queues: <br> https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html <br> - Terraform aws_lambda_function: <br> https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function |
| Thu | - Performed end-to-end testing of the entire system: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Prepared simulated cost data (historical data and test-day data) in S3 for the WARNING and CRITICAL scenarios. <br>&emsp; + Triggered only the Lambda Collector and allowed the system to automatically process the workflow through SQS to the Analyzer without manual intervention. <br>&emsp; + Monitored the complete execution chain: Collector, S3, SQS, Analyzer, and SNS. <br>&emsp; + Summarized the day's progress and shared the results with the team. | 02/07/2026 | 02/07/2026 | - Testing Lambda functions: <br> https://docs.aws.amazon.com/lambda/latest/dg/testing-functions.html <br> - Using Lambda with SQS: <br> https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html |
| Fri | - Verified the results and refined the implementation: <br>&emsp; + Discussed the daily work plan with the team before starting. <br>&emsp; + Confirmed that WARNING and CRITICAL alert emails were delivered correctly with properly formatted currency values ($X.XX). <br>&emsp; + Reviewed CloudWatch Logs to verify that alerts were classified correctly. <br>&emsp; + Restored the threshold values to realistic settings and cleaned up the test data. <br>&emsp; + Summarized the day's progress and shared the results with the team. | 03/07/2026 | 03/07/2026 | |

### Week 8 Achievements:

* **Enhanced Intelligent Anomaly Detection:** Successfully upgraded the Analyzer with two detection criteria: (1) comparing costs against a fixed budget threshold, and (2) detecting cost spikes based on the historical average calculated from previous days' data stored in S3. This is a significant improvement, enabling the system to identify abnormal cost increases even when the absolute threshold has not been exceeded, similar to AWS Cost Anomaly Detection while being fully implemented from scratch.

* **Implemented Multi-Level Alert Classification:** Successfully introduced a three-level alert classification mechanism: INFO, WARNING, and CRITICAL. The email notifications were enhanced to include the alert severity, the specific reason for the alert, the percentage increase, and the historical average cost. In addition, the currency format was standardized to improve readability.

* **Validated All Three Alert Scenarios:** Created simulated cost datasets and successfully tested all three scenarios: INFO (normal cost, no alert), WARNING (budget threshold exceeded), and CRITICAL (significant spike compared to the historical average). The Analyzer correctly classified each scenario in CloudWatch Logs, and email notifications were successfully delivered for both the WARNING and CRITICAL levels.

* **Verified the Fault-Tolerance Mechanism (DLQ):** Successfully tested the error-handling workflow by sending an invalid message that referenced a non-existent file. The message was retried according to the configured retry policy and was automatically moved to the Dead Letter Queue after exceeding the maximum retry limit, ensuring that no data was lost and preventing infinite processing loops when failures occurred.

* **Completed End-to-End System Validation:** Successfully verified the fully automated workflow by triggering only the Lambda Collector. The system automatically executed the remaining workflow through S3, SQS, the Analyzer, and SNS without any manual intervention. The results confirmed that all components were correctly integrated, the system accurately detected WARNING and CRITICAL events, and complete email notifications were delivered successfully, demonstrating that CloudCost Insight operated reliably as a fully automated end-to-end system.

* **Team Collaboration:** Maintained effective collaboration throughout the week. Before starting work each day, I discussed the daily plan with my teammates, and at the end of each day, I summarized the completed tasks to keep everyone informed of the project's progress.