variable "cluster_name" {}
variable "private_subnet_ids" {
  type = list(string)
}
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
