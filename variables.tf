variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}
variable "ami_id" {
  description = "EC2 instance ID"
  type        = string
  default     = "ami-0aba19e56f3eaec05"
}
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
variable "key_name" {
  description = "SSH key"
  type        = string
  default     = "key"
}
variable "aws_access_key" {
  description = "AWS access key ID"
  type        = string
  sensitive   = true
}
variable "aws_secret_key" {
  description = "AWS secret access key"
  type        = string
  sensitive   = true
}