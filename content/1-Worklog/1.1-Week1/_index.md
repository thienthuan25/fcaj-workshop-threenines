---
title: "Worklog Week 1"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 1.1. </b> "
---
<!-- {{% notice warning %}}
⚠️ **Note:** The information below is for reference only, please **do not copy verbatim** for your report, including this warning.
{{% /notice %}} -->


### Week 1 Goals:

* Understand the fundamentals of IAM (Identity and Access Management): Users, Groups, Policies, Roles, MFA, and IAM security tools.
* Get familiar with AWS Access Keys, AWS CLI, AWS CloudShell, and the Shared Responsibility Model for IAM.
* Understand and practice the basics of EC2: instance types, security groups, SSH, EC2 instance roles, purchasing options.
* Understand EC2 Instance Storage: EBS, EBS Snapshots, AMI, EC2 Image Builder, Instance Store, and Amazon FSx.
* Set up AWS Budget to track and control costs during hands-on practice.

### Tasks to be carried out this week:
| Day | Tasks                                                                                                                                                                                   | Start Date | Completion Date | Reference Source                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| Mon | - Learn about IAM (Identity and Access Management): <br>&emsp; + IAM Introduction: Users, Groups, Policies <br>&emsp; + IAM Users & Groups Hands on <br>&emsp; + AWS console simultaneous sign-in <br>&emsp; + IAM Policies <br>&emsp; + IAM Policies hands on <br>&emsp; + IAM MFA overview <br>&emsp; + IAM MFA hands on <br> - **Hands-on practice:** <br>&emsp; + Create IAM Users, Groups <br>&emsp; + Create and attach IAM Policies <br>&emsp; + Enable MFA for an IAM account | 05/11/2026   | 05/11/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| Tue | - In-person learning at the office <br> - Learn about AWS Access Keys, CLI, SDK, and IAM Roles: <br>&emsp; + AWS Access Keys, CLI and SDK <br>&emsp; + AWS CLI setup on Windows and Linux <br>&emsp; + AWS CLI hands on <br>&emsp; + AWS CloudShell <br>&emsp; + IAM roles for AWS services <br>&emsp; + IAM roles hands on <br>&emsp; + IAM security tools <br>&emsp; + IAM security tools hands on <br>&emsp; + Shared responsibility model for IAM <br> - **Hands-on practice:** <br>&emsp; + Install and configure AWS CLI <br>&emsp; + Use AWS CloudShell <br>&emsp; + Create an IAM Role for an AWS service | 05/12/2026   | 05/12/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| Wed | - Learn about EC2 (Elastic Compute Cloud): <br>&emsp; + AWS budget setup <br>&emsp; + EC2 basics <br>&emsp; + EC2 instance types basics <br>&emsp; + Security groups & classic ports overview <br>&emsp; + Security groups hands on <br> - **Hands-on practice:** <br>&emsp; + Set up AWS Budget <br>&emsp; + Create an EC2 instance with EC2 User Data to host a website <br>&emsp; + Configure a Security Group | 05/13/2026   | 05/13/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| Thu | - Learn about EC2 (Elastic Compute Cloud) in more depth: <br>&emsp; + SSH overview <br>&emsp; + How to SSH using Windows <br>&emsp; + How to SSH using Linux <br>&emsp; + SSH troubleshooting <br>&emsp; + EC2 Instance Connect <br>&emsp; + EC2 instance roles demo <br>&emsp; + EC2 instance purchasing options <br>&emsp; + Shared responsibility model for EC2 <br> - **Hands-on practice:** <br>&emsp; + SSH into EC2 from both Windows and Linux <br>&emsp; + Use EC2 Instance Connect <br>&emsp; + Assign an IAM Role to an EC2 instance | 05/14/2026   | 05/14/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |
| Fri | - Learn about EC2 Instance Storage: <br>&emsp; + EBS overview <br>&emsp; + About EBS Multi-Attach <br>&emsp; + EBS hands on <br>&emsp; + EBS snapshots overview <br>&emsp; + EBS snapshot hands on <br>&emsp; + AMI overview <br>&emsp; + AMI hands on <br>&emsp; + EC2 Image Builder overview <br>&emsp; + EC2 Instance Store <br>&emsp; + Shared responsibility model for EC2 storage <br>&emsp; + Amazon FSx overview <br> - **Hands-on practice:** <br>&emsp; + Create and attach an EBS volume <br>&emsp; + Create an EBS Snapshot <br>&emsp; + Create an AMI from an instance | 05/15/2026   | 05/15/2026      | - Ultimate Certified Cloud Practitioner CLF-C02 2026: <br> https://www.udemy.com/course/aws-certified-cloud-practitioner-new/?couponCode=MT260629G3 |


### Week 1 Results Achieved:

* Clearly understood the core concepts of IAM:
  * Users, Groups, Policies, Roles
  * Authentication and authorization mechanisms on AWS

* Successfully created and managed IAM Users and IAM Groups, while also practicing simultaneous sign-in sessions on the AWS console.

* Understood and practiced creating and attaching IAM Policies to Users/Groups; enabled and configured MFA for an IAM account, enhancing login security.

* Gained an understanding of AWS Access Keys, CLI, and SDK; successfully installed and configured AWS CLI on Windows/Linux, including:
  * Access Key
  * Secret Key
  * Default Region

* Became familiar with and practiced using AWS CloudShell directly from the console.

* Understood and practiced creating IAM Roles to grant permissions to AWS services, became familiar with IAM security tools (Credential Report, Access Advisor), and the Shared Responsibility Model for IAM.

* Successfully set up AWS Budget to track costs during the learning and practice process.

* Understood the basic concepts of EC2:
  * Instance types
  * Security Groups & common ports
  * EC2 User Data

* Successfully created an EC2 instance, used EC2 User Data to automatically host a simple website; configured a Security Group to allow access only through the necessary ports.

* Practiced SSH connections into EC2 from both Windows and Linux, and learned how to troubleshoot common SSH errors; used EC2 Instance Connect as an alternative connection method.

* Understood EC2 Instance Roles, the various purchasing options (On-Demand, Reserved, Spot, Savings Plans, etc.), and the Shared Responsibility Model as it applies to EC2.

* Understood EC2 Instance Storage:
  * EBS (Elastic Block Store) and the Multi-Attach feature
  * EBS Snapshots
  * AMI (Amazon Machine Image) and EC2 Image Builder
  * EC2 Instance Store
  * Amazon FSx
  * The Shared Responsibility Model for EC2 storage

* Practiced creating and attaching an EBS volume to an EC2 instance, creating an EBS Snapshot to back up data, and creating an AMI from a running instance to support cloning/launching new instances.