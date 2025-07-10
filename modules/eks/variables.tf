variable "env" {}
variable "aws_region" {}
variable "cluster_name" {}
variable "cluster_version" {}
variable "endpoint_private_access" {}
variable "endpoint_public_access" {}
variable "cluster_role_arn" {}
variable "node_group_role_arn" {}
variable "private_subnet_ids" { type = list(string) }

variable "ondemand_instance_types" { type = list(string) }
variable "spot_instance_types" { type = list(string) }

variable "desired_capacity_on_demand" {}
variable "min_capacity_on_demand" {}
variable "max_capacity_on_demand" {}

variable "desired_capacity_spot" {}
variable "min_capacity_spot" {}
variable "max_capacity_spot" {}
