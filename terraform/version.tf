
terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "terraform-group-threenines"

    workspaces {
      name = "cloudcost-insight"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "CloudCost-Insight"
      ManageBy    = "Terraform"
      Environment = var.environment
    }
  }
}