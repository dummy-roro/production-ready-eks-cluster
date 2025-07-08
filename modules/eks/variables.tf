variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "cluster_name" {}
variable "cluster_version" {}
variable "endpoint_private_access" {}
variable "endpoint_public_access" {}
variable "ondemand_instance_types" {
  type = list(string)
}
variable "spot_instance_types" {
  type = list(string)
}
variable "desired_capacity_on_demand" {}
variable "min_capacity_on_demand" {}
variable "max_capacity_on_demand" {}
variable "desired_capacity_spot" {}
variable "min_capacity_spot" {}
variable "max_capacity_spot" {}
variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}
variable "env" {}
variable "eks_node_group_role_arn" {}
variable "bastion_role_arn" {}
