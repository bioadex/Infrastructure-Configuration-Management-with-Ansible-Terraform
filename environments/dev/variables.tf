variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "flask-app"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-068c0051b15cdb816"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 5000
}

variable "iam_policy_arns" {
  description = "List of IAM policy ARNs to attach to EC2 instances"
  type        = list(string)
  default     = []
}