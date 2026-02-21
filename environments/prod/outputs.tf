output "app_url" {
  description = "URL to access your Flask app"
  value       = "http://${module.compute.public_ip}:5000"
}

output "server_ip" {
  description = "Public IP of the server"
  value       = module.compute.public_ip
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ansible-key-${var.environment}.pem ec2-user@${module.compute.public_ip}"
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.security.security_group_id
}

output "iam_role_name" {
  description = "IAM role attached to the instance"
  value       = module.security.iam_role_name
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = module.security.iam_role_arn
}