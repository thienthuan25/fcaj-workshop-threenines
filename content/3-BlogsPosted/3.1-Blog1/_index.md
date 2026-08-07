---
title: "Blog 1"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# CloudCost Insight - What I Learned from Building a Serverless System to Monitor AWS Costs

Anyone who has just started learning AWS has probably heard the saying:

> "Cloud helps save costs."

However, after learning and starting to work on the project, I realized something more interesting: Cloud only truly saves costs when we know what we are spending money on.

That is also why my team decided to build **CloudCost Insight** - a system that automatically monitors, analyzes, and alerts on AWS costs, instead of having to log in to the AWS Console and check manually every day.

What I want to share in this article is not how to write code, but what I learned after completing the project.

### Why Serverless?

When I first started building the system, I considered using a small EC2 instance to run a cron job. The idea was very simple: every day, EC2 would run a Python script, retrieve data from Cost Explorer, and store it.

However, the more I researched, the more I realized that this approach was not reasonable. The system only runs once per day, while EC2 would have to:

* Run 24/7.
* Cost money even when doing nothing.
* Require patch and server-status management.
* Add more operational work.

Meanwhile, most of the time, the system has nothing to do. Therefore, my team decided to move to a **Serverless** architecture.

Instead of having a server that is always running, AWS only runs code when an event actually occurs. Lambda Collector is triggered by EventBridge on a schedule, then automatically collects cost data and continues the processing flow.

### Event-driven Helps Decouple Components

One of the clearest things I learned from the project was how to build a system using an **event-driven** architecture.

Instead of allowing components to call each other directly, my team separated them through events:

* EventBridge only knows how to trigger Lambda Collector.
* Collector only knows how to retrieve data and send messages to SQS.
* Analyzer only knows how to read messages from SQS and analyze data.
* SNS only knows how to send alert emails.
* Dashboard only knows how to call the API to display data.

No component depends too heavily on another component. Therefore, when we want to change the processing logic, the team only needs to modify the relevant Lambda or component.

This was the first time I truly understood what an event-driven architecture is, after previously only reading about it in documentation.

### There Were Services I Previously Only Knew by Name

Before working on this project, I had learned about many AWS services in the following way:

* What is Lambda?
* What is SNS used for?
* How does SQS work?

Only when I built the system myself did I understand how they connect with each other.

For example, Amazon SQS is not just a queue. It helps Lambda Collector avoid having to care whether Lambda Analyzer is busy or idle. Collector only needs to send an event to the queue, and Analyzer will process the event when it is able to.

Similarly, CloudWatch Alarm is not only for viewing logs. In CloudCost Insight, CloudWatch is used to detect:

* Lambda errors.
* Messages sent to the Dead Letter Queue.
* Incidents that need alert emails to be sent immediately.

One interesting thing I discovered during testing is that CloudWatch Alarm does not send emails continuously. The Alarm only sends notifications when its status changes from `OK` to `ALARM`, or from `ALARM` back to `OK`.

### Infrastructure as Code with Terraform

This is probably my favorite part of the project.

The entire CloudCost Insight system is deployed using Terraform. This means that when I want to rebuild the system, I only need to run:

```bash
terraform init
terraform plan
terraform apply
```

After a few minutes, the necessary resources can be created again on AWS.

There is no need to remember:

* Whether the S3 Bucket has been created.
* What the IAM Role is called.
* Whether the SQS Queue has been configured correctly.
* Whether Lambda has environment variables.

Terraform automates these tasks. This became even clearer during the Workshop-writing phase. Every member of the team had to redeploy the project from scratch. If it had been done manually, it would certainly have taken a lot of time. However, thanks to Infrastructure as Code, recreating the system became much simpler and more consistent.

### Serverless Does Not Only Help Save Money

At first, I thought Serverless only had cost advantages. After completing the project, I realized that the greatest benefit lies in the system design.

Serverless helps with:

* No need to manage servers.
* Automatic scaling based on load.
* Easier separation of functions.
* Easier testing.
* Easier redeployment.
* Paying only when resources actually run.

For a learning project or a system with a low processing frequency, this is a very worthwhile option to consider.

### Challenges Encountered

During the project, my team also encountered several practical issues:

* Cost Explorer does not update data in real time.
* Missing IAM permissions can cause Lambda to fail.
* API Gateway CORS can prevent the frontend from calling the API.
* SNS requires email confirmation before sending alerts.
* SQS needs retry and Dead Letter Queue configuration to avoid missing failed messages.

Although these issues were not major, they helped me better understand how AWS services operate when combined in a real system.

### What I Learned After This Project

If we only look at the list of services, CloudCost Insight uses quite a lot of components. However, the most valuable thing I learned was not learning more AWS services, but learning how to combine small services into a complete system.

Each service only solves a specific problem:

* EventBridge handles scheduling.
* Lambda handles logic.
* S3 stores data.
* SQS decouples components.
* SNS sends alerts.
* CloudWatch monitors the system.
* Terraform deploys the infrastructure.

When combined properly, they create an automated, scalable, and maintainable system.

I hope these experiences provide everyone with a more practical perspective when learning and deploying AWS.

![Blog 1](/workshop-fcaj-intern/images/2-Proposal/diagram_architecture.png)

### Article Link

[CloudCost Insight - What I Learned from Building a Serverless System to Monitor AWS Costs](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2223252578439702/?rdid=HXH21Uqn6t5ZQ4L4#)