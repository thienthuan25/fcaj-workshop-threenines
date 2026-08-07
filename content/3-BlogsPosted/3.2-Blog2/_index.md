---
title: "Blog 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.2. </b> "
---

# Amazon EventBridge Scheduler - A Small Service That Can Replace Many Cron Jobs

While learning AWS at First Cloud AI Journey, I had the opportunity to explore many services. Some services are very well known, such as EC2, Lambda, and S3, but there are also services that are mentioned less often even though they are very useful in real-world systems.

*One of them is Amazon EventBridge Scheduler.*

When I first started learning AWS, whenever I needed to run a task on a schedule, I simply thought about creating an EventBridge Rule with a `cron` or `rate` expression. After researching further through AWS Blogs and official documentation, I learned that AWS has developed a dedicated scheduling service called Amazon EventBridge Scheduler, with many more powerful features.

### What is Amazon EventBridge Scheduler?

Amazon EventBridge Scheduler is a Serverless service that helps schedule task execution on AWS without having to build a cron server or manage infrastructure.

Instead of maintaining a server to run cron jobs, we only need to configure the execution time, and Scheduler will automatically trigger the desired service.

Amazon EventBridge Scheduler can directly invoke many AWS services, such as:

* AWS Lambda.
* AWS Step Functions.
* Amazon ECS Tasks.
* AWS Batch Jobs.
* Amazon SQS.
* Amazon SNS.
* Amazon EventBridge Event Bus.
* API Destination.
* And more than 270 AWS services through the AWS SDK.

What I like most is that there is almost no need to write additional intermediate code.

### How is EventBridge Scheduler Different from EventBridge Rule?

This was something I used to misunderstand. Previously, I always thought that EventBridge Rule was the tool used to trigger Lambda Collector every day to collect AWS cost data in the CloudCost Insight project.

After learning about EventBridge Scheduler, I realized that if I were building or improving the project, I would consider using Scheduler instead of EventBridge Rule.

Some benefits of EventBridge Scheduler that I believe can be applied are:

* Supports retries when Lambda encounters errors.
* Has a Dead Letter Queue to handle failed requests.
* Makes it easy to configure execution times based on the Vietnam time zone.
* Has Flexible Time Windows to prevent many tasks from running at the same time.
* Is easy to scale when the system grows larger.

It is a small change, but it makes the system more professional and flexible.

### Applying It to CloudCost Insight

In CloudCost Insight, Lambda Collector runs periodically to retrieve cost data from AWS Cost Explorer. Currently, EventBridge Rule can meet the requirement of triggering Lambda on a schedule.

However, EventBridge Scheduler is a suitable improvement direction because it can help the system:

* Configure schedules based on a specific time zone.
* Retry when Lambda Collector encounters temporary errors.
* Send failed requests to a Dead Letter Queue for later inspection.
* Reduce the risk of multiple scheduled tasks running at the same time.
* Manage schedules more independently and clearly.

For example, instead of running Collector at a fixed time in UTC, we can configure Scheduler to run at a specific time in the Vietnam time zone. This makes monitoring and operating the system more convenient.

### What Did I Learn?

Previously, I thought that once I knew EventBridge, there was no need to learn more. However, after reading AWS Blogs and official documentation, I realized that AWS continuously develops new services to solve very specific problems.

Amazon EventBridge Scheduler is a typical example. It is not an overly complex service, but it helps simplify many tasks during the process of building Serverless systems.

I think this is a service worth learning about for anyone studying AWS or building applications with scheduled tasks.

![Blog 2](/workshop-fcaj-intern/images/3-Blog/3.2-Blog-2/blog_2.png)

### Article Link

[Amazon EventBridge Scheduler - A Small Service That Can Replace Many Cron Jobs](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2225954698169490/?rdid=gj7NEFNAmPKdfzze#)

### References

- [Introducing Amazon EventBridge Scheduler](https://aws.amazon.com/vi/blogs/compute/introducing-amazon-eventbridge-scheduler/)
- [Amazon EventBridge Scheduler Documentation](https://docs.aws.amazon.com/scheduler/latest/UserGuide/what-is-scheduler.html)