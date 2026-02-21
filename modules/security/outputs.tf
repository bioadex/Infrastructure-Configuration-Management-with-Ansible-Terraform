output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.app.id
}

output "key_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.deployer.key_name
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.ec2_role.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.ec2_role.arn
}