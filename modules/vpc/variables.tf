variable "vpc_cidr_block" {}
variable "vpc_name" {}
variable "igw_name" {}
variable "pub_subnet_count" {}
variable "pub_cidr_block" { type = list(string) }
variable "pub_availability_zone" { type = list(string) }
variable "pub_sub_name" {}
variable "pri_subnet_count" {}
variable "pri_cidr_block" { type = list(string) }
variable "pri_availability_zone" { type = list(string) }
variable "pri_sub_name" {}
variable "public_rt_name" {}
variable "private_rt_name" {}
variable "eip_name" {}
variable "ngw_name" {}
