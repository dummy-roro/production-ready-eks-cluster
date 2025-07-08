variable "env" {
  type        = string
  description = "Deployment environment name (e.g., dev, prod)."
}

variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources in."
}

variable "cluster_name" {
  type        = string
  description = "The base name for the EKS cluster and its resources."
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  type = list(object({
    az   = string
    cidr = string
  }))
  description = "A list of objects defining the public subnets."
}

variable "private_subnets" {
  type = list(object({
    az   = string
    cidr = string
  }))
  description = "A list of objects defining the private subnets."
}

variable "cluster_version" {
  type        = string
  description = "The Kubernetes version for the EKS cluster."
}

variable "node_groups" {
  type        = any
  description = "A map of objects defining the EKS managed node groups."
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
  description = "A list of EKS add-ons to install."
  default     = []
}

variable "endpoint_public_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
  default     = false
}

variable "endpoint_private_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
  default     = true
}

variable "trusted_security_group_id" {
  type        = string
  description = "The ID of a security group that is allowed to access the EKS API server private endpoint."
}
