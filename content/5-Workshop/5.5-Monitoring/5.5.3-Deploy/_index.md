---
title : "Deployment"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.5.3 </b> "
---

1. In the WSL2 terminal, deploy the CloudWatch Alarms you have just configured:

```bash
terraform apply
```

2. After the deployment completes successfully, open the AWS Console and verify the list of CloudWatch Alarms. Initially, all alarms should be in the **OK** state because no errors have occurred yet:

![Monitoring](/fcaj-workshop-threenines/images/5-Workshop/5.5-Monitoring/5.5.3-Deploy/deploy_1.png)

After completing this section, the system will have a complete self monitoring capability. Whenever a Lambda function encounters an error or a message is sent to the **Dead Letter Queue**, you will receive an email notification so that the issue can be investigated and resolved promptly.

#### Next Content

- [Dashboard](5-Workshop/5.6-Dashboard/)