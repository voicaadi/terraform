terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
module "network" {
  source = "./module"

  web_security_group_id = aws_security_group.web.id
}
resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow SSH and http from ALB"
  vpc_id      = module.network.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["188.173.134.111/32"]
  }
  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "web"
    ManagedBy = "Terraform"
  }
}
resource "aws_instance" "web_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data              = file("${path.module}/userdata.sh")
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = module.network.public_subnet_ids[0]

  iam_instance_profile = module.network.ssm_instance_profile_name
  
  tags = {
    Name      = "web"
    ManagedBy = "Terraform"
  }
}
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = module.network.alb_target_group_arn
  target_id        = aws_instance.web_instance.id
  port             = 80
}

