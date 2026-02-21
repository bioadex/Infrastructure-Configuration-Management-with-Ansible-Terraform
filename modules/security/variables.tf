variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH"
  type        = string
}

variable "app_port" {
  description = "Port for the application"
  type        = number
  default     = 5000
}

variable "iam_policy_arns" {
  description = "List of IAM policy ARNs to attach to the instance role"
  type        = list(string)
  default     = []
}