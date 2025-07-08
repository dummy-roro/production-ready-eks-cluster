variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "cluster_name" {
  description = "The name for your EKS cluster."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "The CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "The CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "ssh_key_name" {
  description = "The name of the EC2 key pair for SSH access to the jump host. You must create this beforehand."
  type        = string
}

variable "my_ip" {
  description = "Your public IP address to allow SSH access to the jump host. (e.g., '1.2.3.4/32')"
  type        = string
}
