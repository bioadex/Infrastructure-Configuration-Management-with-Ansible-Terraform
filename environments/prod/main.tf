terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "flask-app-terraform-state-aka-tech-it"
    key            = "env/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../../modules/network"

  environment         = var.environment
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  aws_region          = var.aws_region
}

module "security" {
  source = "../../modules/security"

  environment      = var.environment
  project_name     = var.project_name
  vpc_id           = module.network.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
  app_port         = var.app_port
  iam_policy_arns  = var.iam_policy_arns
}

module "compute" {
  source = "../../modules/compute"

  environment            = var.environment
  project_name           = var.project_name
  subnet_id              = module.network.public_subnet_id
  security_group_id      = module.security.security_group_id
  key_name               = module.security.key_name
  instance_type          = var.instance_type
  ami_id                 = var.ami_id
  instance_profile_name  = module.security.instance_profile_name
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/../../inventory.tpl", {
    app_ip = module.compute.public_ip
    ssh_key_path = "${path.module}/environments/${var.environment}/ansible-key-${var.environment}.pem"
  })
  filename = "${path.module}/inventory.ini"
}