# terraform-multi-ec2-app/variables.tf

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "MultiEC2App"
}

variable "region" {
  description = "The AWS region to deploy resources in (e.g., us-east-1, ap-south-1)"
  type        = string
  default     = "us-east-1"
}

variable "instance_type_lb" {
  description = "Instance type for the Load Balancer"
  type        = string
  default     = "t2.micro"
}

variable "instance_type_app" {
  description = "Instance type for the Application Server"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
  # IMPORTANT: Find the latest **Ubuntu Server 22.04 LTS (HVM), SSD Volume Type** AMI for your chosen region!
  # You can find this in the AWS EC2 console, launch instance, select Ubuntu.
  # For us-east-1, a common one might be "ami-053b0d3d5f6629007" (Ubuntu 22.04 LTS, amd64) as of late 2024.
  # THIS IS AN EXAMPLE. PLEASE VERIFY THE LATEST ONE IN YOUR CONSOLE.
  default = "ami-0a7d80731ae1b2435" # EXAMPLE: Ubuntu 22.04 LTS for us-east-1
}

variable "key_name" {
  description = "The name of the EC2 Key Pair to use"
  type        = string
  default     = "my-ec2-keypair" # IMPORTANT: Ensure this key pair exists in your AWS region!
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}
