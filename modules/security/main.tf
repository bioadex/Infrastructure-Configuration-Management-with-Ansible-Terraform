resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group for Flask app in ${var.environment}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    description = "SSH access"
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask app"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-sg"
    Environment = var.environment
  }
}

# SSH Key Pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh

  tags = {
    Name        = "${var.project_name}-${var.environment}-key"
    Environment = var.environment
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.root}/ansible-key-${var.environment}.pem"
  file_permission = "0600"
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ec2_policies" {
  count      = length(var.iam_policy_arns)
  role       = aws_iam_role.ec2_role.name
  policy_arn = var.iam_policy_arns[count.index]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-profile"
    Environment = var.environment
  }
}