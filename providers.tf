# terraform-multi-ec2-app/providers.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Or your desired compatible version
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # Or your desired region (e.g., "ap-south-1")
}
