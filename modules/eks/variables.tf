variable "cluster_name" {}
variable "cluster_version" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "endpoint_private_access" {}
variable "endpoint_public_access" {}
variable "eks_security_group_name" {}
