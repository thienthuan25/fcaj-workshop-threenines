---
title : "Clean Up Resources"
date : 2024-01-01
weight : 8
chapter : false
pre : " <b> 5.8 </b> "
---

#### Cleanup

1. We will use **Terraform** to delete all the resources that were created, including **Lambda**, **IAM Roles**, **SNS**, **SQS**, **EventBridge**, **CloudWatch Alarms**, **API Gateway**, **CloudFront**, and the **S3** buckets.

```bash
terraform destroy
```

2. Type `yes` to confirm.

![Cleanup](/fcaj-workshop-threenines/images/5-Workshop/5.8-Cleanup/cleanup_1.png)

3. Wait for the cleanup process to complete.

![Cleanup](/fcaj-workshop-threenines/images/5-Workshop/5.8-Cleanup/cleanup_2.png)

4. After the **destroy** operation is complete, you should verify in the AWS Console that all resources have been deleted successfully. Check each service used in this workshop, including **S3**, **Lambda**, **SNS**, **SQS**, **EventBridge**, **CloudWatch Alarms**, **API Gateway**, and **CloudFront**.

5. Some components are not managed by **Terraform**, so they must be cleaned up manually if you want to remove everything completely:

- If you no longer need it, you can delete the **Workspace** in **HCP Terraform**.
- Disable or delete the **Access Key** of your **IAM User** if it is no longer in use to maintain security.
- Verify that the **SNS Subscription** has been removed along with the SNS topic.

#### Summary

After completing the steps above, all resources of the **CloudCost Insight** system have been completely removed, ensuring that no additional charges will be incurred. Being able to clean up the entire infrastructure with a single command clearly demonstrates the advantages of managing infrastructure as **Infrastructure as Code (IaC)** using **Terraform**.

The **CloudCost Insight** cost monitoring and alerting system workshop is now complete. Throughout this workshop, we covered the entire process, from designing the architecture and provisioning the infrastructure to developing the application logic, configuring monitoring, building the Web Dashboard, testing the system, and finally cleaning up all resources.