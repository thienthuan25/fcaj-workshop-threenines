---
title: "Week 3 Worklog"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.3. </b> "
---


### Week 3 Goals:

* Understand the tools for deploying and managing infrastructure at scale on AWS: CloudFormation, CDK, Beanstalk, CodePipeline, Systems Manager.
* Learn how to leverage AWS's global infrastructure: Route 53, CloudFront, Global Accelerator, Outposts, Local Zones.
* Understand cloud integration services: SQS, SNS, Kinesis, Amazon MQ.
* Master cloud monitoring tools: CloudWatch, EventBridge, CloudTrail, X-Ray, AWS Health Dashboard.
* Understand security and compliance on AWS: WAF, Shield, KMS, Secrets Manager, GuardDuty, Inspector, IAM Access Analyzer, and related services.
* Understand AWS network architecture: VPC, Subnet, Internet Gateway, NAT, Security Groups, NACL, VPN, Direct Connect, Transit Gateway.
* Gain an overview of AWS Machine Learning services: Rekognition, Transcribe, Polly, SageMaker, Kendra, Textract, and related services.

### Tasks to be carried out this week:
| Day | Tasks                                                                                                                                                                                   | Start Date | Completion Date | Reference Source                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| Mon | - Learn about Deployments & Managing Infrastructure at Scale: <br>&emsp; + CloudFormation overview <br>&emsp; + CloudFormation hands on <br>&emsp; + CDK overview <br>&emsp; + Beanstalk overview <br>&emsp; + Beanstalk hands on <br>&emsp; + CodeDeploy overview <br>&emsp; + CodeCommit overview <br>&emsp; + CodeBuild overview <br>&emsp; + CodePipeline overview <br>&emsp; + CodeArtifact overview <br>&emsp; + Systems Manager (SSM) overview <br>&emsp; + SSM Session Manager <br>&emsp; + SSM Parameter Store <br> - **Hands-on practice:** <br>&emsp; + Create a stack with CloudFormation <br>&emsp; + Deploy an application with Elastic Beanstalk <br>&emsp; + Use SSM Session Manager to connect to EC2 without SSH <br> - Comprehensive review quiz | 05/25/2026   | 05/25/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| Tue | - Learn about Leveraging the AWS Global Infrastructure: <br>&emsp; + Why global application? <br>&emsp; + Route 53 overview <br>&emsp; + Route 53 hands on <br>&emsp; + CloudFront overview <br>&emsp; + CloudFront hands on <br>&emsp; + S3 Transfer Acceleration <br>&emsp; + AWS Global Accelerator <br>&emsp; + AWS Outposts <br>&emsp; + AWS Wavelength <br>&emsp; + AWS Local Zones <br>&emsp; + Global applications architecture <br> - Learn about Cloud Integrations: <br>&emsp; + Cloud integration overview <br>&emsp; + SQS overview <br>&emsp; + SQS hands on <br>&emsp; + Kinesis overview <br>&emsp; + SNS overview <br>&emsp; + SNS hands on <br>&emsp; + Amazon MQ overview <br> - **Hands-on practice:** <br>&emsp; + Configure Route 53 <br>&emsp; + Create a CloudFront distribution <br>&emsp; + Create an SQS queue and send/receive messages <br>&emsp; + Create an SNS topic and subscription | 05/26/2026   | 05/26/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| Wed | - Learn about Cloud Monitoring: <br>&emsp; + CloudWatch Metrics & CloudWatch Alarms <br>&emsp; + CloudWatch Metrics & CloudWatch Alarms hands on <br>&emsp; + CloudWatch Logs overview <br>&emsp; + CloudWatch Logs hands on <br>&emsp; + EventBridge overview <br>&emsp; + EventBridge hands on <br>&emsp; + CloudTrail overview <br>&emsp; + CloudTrail hands on <br>&emsp; + X-Ray overview <br>&emsp; + AWS Health Dashboard <br>&emsp; + AWS Health Dashboard hands on <br> - Learn about Security & Compliance: <br>&emsp; + Shared Responsibility Model: reminders & examples <br>&emsp; + DDoS protection: WAF & Shield <br>&emsp; + AWS Network Firewall <br>&emsp; + AWS Firewall Manager <br>&emsp; + Penetration testing <br>&emsp; + Encryption with KMS & CloudHSM <br>&emsp; + Encryption with KMS & CloudHSM hands on <br>&emsp; + AWS Certificate Manager (ACM) overview <br>&emsp; + Secrets Manager overview <br>&emsp; + Artifact overview <br>&emsp; + GuardDuty overview <br>&emsp; + Inspector overview <br>&emsp; + Config overview <br>&emsp; + Macie overview <br>&emsp; + Security Hub overview <br>&emsp; + Amazon Detective overview <br>&emsp; + AWS Abuse <br>&emsp; + Root user privileges <br>&emsp; + IAM Access Analyzer <br> - **Hands-on practice:** <br>&emsp; + Create a CloudWatch Alarm that sends notifications via SNS <br>&emsp; + Create an EventBridge rule to trigger a Lambda function <br>&emsp; + Create a KMS key and encrypt an S3 object <br>&emsp; + Enable GuardDuty and review findings | 05/27/2026   | 05/27/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| Thu | - Learn about VPC & Networking: <br>&emsp; + VPC overview <br>&emsp; + IP address in AWS <br>&emsp; + VPC, Subnet, Internet Gateway & NAT Gateways <br>&emsp; + VPC, Subnet, Internet Gateway & NAT Gateways hands on <br>&emsp; + Security Groups & Network Access Control List (NACL) <br>&emsp; + VPC Flow Logs & VPC Peering <br>&emsp; + VPC Endpoints - Interface & Gateway (S3 & DynamoDB) <br>&emsp; + PrivateLink <br>&emsp; + Direct Connect & Site-to-Site VPN <br>&emsp; + Client VPN <br>&emsp; + Transit Gateway overview <br> - **Hands-on practice:** <br>&emsp; + Create a VPC with public and private subnets <br>&emsp; + Configure Internet Gateway and NAT Gateway <br>&emsp; + Configure Security Group and NACL <br>&emsp; + Create a VPC Endpoint for S3 | 05/28/2026   | 05/28/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| Fri | - Learn about Machine Learning on AWS: <br>&emsp; + Rekognition overview <br>&emsp; + Transcribe overview <br>&emsp; + Polly overview <br>&emsp; + Translate overview <br>&emsp; + Lex + Connect overview <br>&emsp; + Comprehend overview <br>&emsp; + SageMaker AI overview <br>&emsp; + Kendra overview <br>&emsp; + Personalize overview <br>&emsp; + Textract overview <br> - Review and consolidate all knowledge from the 3 weeks | 05/29/2026   | 05/29/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |


### Week 3 Results Achieved:

* Understood the tools for deploying and managing infrastructure at scale:
  * CloudFormation to define infrastructure as code (IaC)
  * CDK (Cloud Development Kit) as a higher-level abstraction layer on top of CloudFormation
  * Elastic Beanstalk for rapid application deployment without the need to manage underlying infrastructure
  * AWS CI/CD toolset: CodeCommit, CodeBuild, CodeDeploy, CodePipeline, CodeArtifact
  * Systems Manager (SSM): manage EC2 without SSH via Session Manager, store configuration with Parameter Store

* Understood the rationale and methods for deploying global applications on AWS:
  * Route 53 for DNS routing
  * CloudFront as a CDN for global content delivery
  * S3 Transfer Acceleration and AWS Global Accelerator to improve data transfer speeds
  * AWS Outposts, Wavelength, and Local Zones for specialized use cases

* Understood cloud integration and messaging services:
  * SQS (Simple Queue Service) for message queuing
  * SNS (Simple Notification Service) for pub/sub messaging
  * Kinesis for real-time data stream processing
  * Amazon MQ as a message broker compatible with open messaging protocols

* Mastered cloud monitoring tools:
  * CloudWatch Metrics, Alarms, and Logs for resource monitoring and alerting
  * EventBridge for building event-driven workflows
  * CloudTrail for auditing API call history
  * X-Ray for tracing and analyzing application performance
  * AWS Health Dashboard for monitoring the status of AWS services

* Gained a comprehensive understanding of security and compliance on AWS:
  * WAF, Shield, and Network Firewall for DDoS and network attack protection
  * KMS and CloudHSM for data encryption
  * Secrets Manager for managing sensitive credentials
  * GuardDuty, Inspector, Macie, Security Hub, and Detective for threat detection and investigation
  * IAM Access Analyzer, Config, and Artifact for governance and compliance

* Understood AWS network architecture:
  * VPC, Subnet (public/private), Internet Gateway, NAT Gateway
  * Differentiated between Security Groups and NACLs
  * VPC Flow Logs, VPC Peering, VPC Endpoints
  * PrivateLink, Direct Connect, Site-to-Site VPN, Client VPN, and Transit Gateway

* Gained an overview of AWS Machine Learning services:
  * Rekognition (image/video recognition), Transcribe (speech-to-text), Polly (text-to-speech), Translate
  * Lex + Connect for chatbots and contact centers
  * Comprehend (natural language processing), SageMaker AI (building and training ML models)
  * Kendra (intelligent search), Personalize (personalized recommendations), Textract (text extraction from documents)

* Completed the review and consolidation of all AWS Cloud Practitioner knowledge after 3 weeks of study.