terraform {
  required_version = "~>1.6.0"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.1.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.9.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = var.assume_role
  }
}

