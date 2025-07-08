# General
variable "env" {
  description = "The deployment environment name."
  type        = string
}

variable "aws_region" {
  description = "The AWS region for deployment."
  type        = string
}

# VPC Networking
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC."
  type        = string
}

variable "igw_name" {
  description = "Name for the Internet Gateway."
  type        = string
}

variable "pub_subnet_count" {
  description = "Number of public subnets."
  type        = number
}

variable "pub_cidr_block" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
}

variable "pub_availability_zone" {
  description = "Availability Zones for public subnets."
  type        = list(string)
}

variable "pub_sub_name" {
  description = "Base name for public subnets."
  type        = string
}

variable "pri_subnet_count" {
  description = "Number of private subnets."
  type        = number
}

variable "pri_cidr_block" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "pri_availability_zone" {
  description = "Availability Zones for private subnets."
  type        = list(string)
}

variable "pri_sub_name" {
  description = "Base name for private subnets."
  type        = string
}

variable "public_rt_name" {
  description = "Name for the public route table."
  type        = string
}

variable "private_rt_name" {
  description = "Base name for private route tables."
  type        = string
}

variable "eip_name" {
  description = "Base name for Elastic IPs."
  type        = string
}

variable "ngw_name" {
  description = "Base name for NAT Gateways."
  type        = string
}

variable "eks_sg" {
  description = "Name for the EKS Cluster security group."
  type        = string
}

# EKS Cluster
variable "is_eks_cluster_enabled" {
  description = "Flag to enable EKS cluster creation."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint."
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint."
  type        = bool
  default     = false
}

# EKS Node Groups
variable "ondemand_instance_types" {
  description = "Instance types for the on-demand node group."
  type        = list(string)
}

variable "spot_instance_types" {
  description = "Instance types for the spot node group."
  type        = list(string)
}

variable "desired_capacity_on_demand" {
  description = "Desired number of on-demand nodes."
  type        = string
}

variable "min_capacity_on_demand" {
  description = "Minimum number of on-demand nodes."
  type        = string
}

variable "max_capacity_on_demand" {
  description = "Maximum number of on-demand nodes."
  type        = string
}

variable "desired_capacity_spot" {
  description = "Desired number of spot nodes."
  type        = string
}

variable "min_capacity_spot" {
  description = "Minimum number of spot nodes."
  type        = string
}

variable "max_capacity_spot" {
  description = "Maximum number of spot nodes."
  type        = string
}

# EKS Addons
variable "addons" {
  description = "A list of EKS addons to install."
  type = list(object({
    name    = string
    version = string
  }))
  default = []
}
