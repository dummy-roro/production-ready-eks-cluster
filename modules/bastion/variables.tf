variable "aws_region" {}
variable "cluster_name" {}
variable "cluster_version" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "bastion_key_pair_name" {}
variable "bastion_instance_profile" {}
