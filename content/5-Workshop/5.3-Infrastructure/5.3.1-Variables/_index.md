---
title : "Declare Input Variables"
date : 2024-01-01
weight : 1
chapter : false
pre : " <b> 5.3.1 </b> "
---

First, create a file named `variables.tf` to define the input variables shared across the entire project. Keeping variables in a separate file makes the configuration easier to customize without modifying the resource definitions directly.

```hcl
# Defines the AWS Region where the infrastructure resources will be deployed
variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "us-east-1"
}

# Defines the current deployment environment of the system
variable "environment" {
  description = "Deployment environment (dev/test/prod)"
  type        = string
  default     = "dev"
}

# Specifies the project name, which is used as a prefix when naming resources such as Lambda functions, S3 buckets, and IAM roles
variable "project_name" {
  description = "Project name, used as a prefix for naming resources"
  type        = string
  default     = "cloudcost-insight"
}

# Specifies the email address that will receive alert notifications from the system
variable "alert_email" {
  description = "Email address for receiving cost alert via SNS"
  type        = string

}

# Defines the EventBridge schedule expression that determines how frequently the automated task runs
variable "schedule_expression" {
  description = "Scheduled expression for EventBridge"
  type        = string
  default     = "rate(1 day)"
}

# Defines the cost threshold in USD
variable "cost_threshold_usd" {
  description = "Cost threshold (USD) that triggers an alert"
  type        = number
  default     = 10
}

# Defines the multiplier used to detect abnormal cost increases by comparing the current cost with the historical average multiplied by this value
variable "spike_multiplier" {
  description = "Spike multiplier: if cost > historical average * this multiplier, it is considered an abnormal spike"
  type        = number
  default     = 1.5 # An alert is triggered when the current cost exceeds 1.5 times the historical average.
}

# Specifies the number of previous days used to calculate the historical average cost
variable "history_days" {
  description = "Number of historical days used to calculate the average cost (for spike detection)"
  type        = number
  default     = 7 # Calculates the average cost over the most recent 7 days.
}
```