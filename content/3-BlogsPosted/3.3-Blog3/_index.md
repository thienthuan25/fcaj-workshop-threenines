---
title: "Blog 3"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 3.3. </b> "
---

# From CloudCost Insight to an AI FinOps Agent with Amazon Bedrock AgentCore

During my studies at FCAJ and while working on the CloudCost Insight group project, the initial goal of my team and me was quite clear: automatically collect AWS costs, detect anomalies, send email alerts, and visualize data on a Dashboard.

The system currently uses Amazon EventBridge, AWS Lambda, Amazon S3, Amazon SQS, Amazon SNS, Amazon CloudWatch, Amazon API Gateway, Amazon CloudFront, and Amazon Cognito. When costs exceed the threshold or increase suddenly, Lambda Analyzer detects and sends an alert.

However, after completing this version, I realized an interesting question:

> What if users do not only want to receive alerts, but also want to ask: “Why did EC2 costs increase?” or “What should I optimize first?”

That was when I learned about Amazon Bedrock AgentCore.

### What is Amazon Bedrock AgentCore?

Amazon Bedrock AgentCore is an AWS managed platform that helps build, deploy, and operate AI Agents in production environments.

Instead of only calling a Large Language Model to answer questions, AgentCore supports Agents in accessing tools, data, and APIs, while also performing multiple processing steps to complete a task.

AgentCore does not require implementers to manage the runtime infrastructure for Agents themselves. The platform supports different frameworks and models, while also providing components for runtime, memory, identity, tool integration, and observability.

### Why Is an AI Agent Different from a Traditional Chatbot?

A basic chatbot usually operates using the following model:

```text
User
→ Prompt
→ LLM
→ Answer
```

Meanwhile, an AI Agent can perform a sequence of actions:

```text
User asks a question
→ Agent analyzes the request
→ Calls the appropriate tool or API
→ Queries data
→ Analyzes the results
→ Provides an answer or recommends an action
```

For example, with CloudCost Insight, a user may ask:

> “Why is today's cost higher than the average?”

A FinOps Agent can:

* Call CloudCost Insight APIs to retrieve cost data.
* Identify the services with the highest cost increases.
* Compare current costs with historical data in S3.
* Analyze whether the cost increase is caused by exceeding a threshold or by a sudden spike.
* Respond in natural language and suggest the next investigation steps.

### Notable Components of AgentCore

#### AgentCore Runtime

Runtime provides an isolated and scalable environment to run Agents. This is where the Agent performs reasoning, calls tools, and processes tasks that may take a long time.

Instead of having to deploy Agents on EC2, ECS, or Kubernetes, developers can focus on Agent logic and let AWS manage the runtime layer.

#### AgentCore Gateway

Gateway helps connect Agents with existing tools and services. An API or Lambda function can be converted into a tool that an Agent can discover and invoke through the Model Context Protocol (MCP).

This component is particularly suitable for CloudCost Insight. APIs such as retrieving daily costs, retrieving top services, or checking anomaly status can become tools for a FinOps Agent.

```text
FinOps Agent
→ AgentCore Gateway / MCP
→ Lambda API
→ S3 Cost Data
```

#### AgentCore Identity

When an Agent needs to access AWS resources or third-party tools, identity is a very important component. AgentCore Identity supports authentication and authorization mechanisms so that Agents can act securely on behalf of users or systems.

In CloudCost Insight, this component can be integrated with the existing Amazon Cognito setup to ensure that the Agent only accesses cost data that users are authorized to view.

#### AgentCore Memory

Memory helps an Agent maintain context during conversations or store necessary information between sessions.

For example, if a user has already asked about EC2 costs this week, the Agent can understand the next question:

> “What about Lambda?”

without requiring the user to repeat the entire context.

#### AgentCore Observability

When deploying an AI Agent to production, the questions are not only whether the Agent can provide an answer, but also:

* Which tools did the Agent call?
* Did the tool calls succeed?
* How long did the Agent take to complete a task?
* Did the Agent provide an incorrect answer or go beyond its intended scope?

AgentCore Observability provides end-to-end monitoring capabilities for Agent activities and integrates with Amazon CloudWatch. This is an important factor for debugging, evaluating, and improving Agents over time.

### CloudCost Insight Expansion Idea

The current version of the group project already has the ability to:

* Collect AWS cost data on a schedule.
* Detect costs that exceed thresholds and sudden spikes.
* Send alerts through SNS Email.
* Display a Dashboard with Cognito authentication.
* Handle errors using SQS partial batch failure, DLQ, and CloudWatch Alarm.
* Deploy infrastructure using Terraform and CI/CD.

In the next version, I would like to experiment with an AI FinOps Agent model:

```text
User
→ Dashboard
→ Amazon Cognito
→ FinOps Agent on Bedrock AgentCore
→ AgentCore Gateway / MCP
→ CloudCost Insight APIs
→ S3 Cost Data
→ Analysis and optimization recommendations
```

The Agent can help users answer questions such as:

* Which service has incurred the highest cost in the past 7 days?
* Which day had abnormal costs?
* By what percentage did today's cost increase compared to the historical average?
* Which resources should I check first to optimize costs?

### Conclusion

AI Agents do not replace Cloud or FinOps engineers. However, if designed properly in terms of security, data, and observability, an Agent can become a helpful teammate that reduces investigation time and delivers necessary information to users more quickly.

Amazon Bedrock AgentCore opens up an interesting development direction for CloudCost Insight: from an automated cost monitoring and alerting system, it can evolve into an AI FinOps Agent that supports cost analysis and optimization recommendations.

### Article Link

[From CloudCost Insight to an AI FinOps Agent with Amazon Bedrock AgentCore](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2237361750362118/?rdid=XfoUyid6NZXJYRyp#)