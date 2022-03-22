terraform {
  required_version = ">= 0.14.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.67.0"
    }
  }
}

provider "aws" {
  alias = "route53"
}