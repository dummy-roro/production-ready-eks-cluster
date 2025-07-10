provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source                 = "./modules/vpc"
  vpc_cidr_block         = var.vpc_cidr_block
  vpc_name               = var.vpc_name
  igw_name               = var.igw_name
  pub_subnet_count       = var.pub_subnet_count
  pub_cidr_block         = var.pub_cidr_block
  pub_availability_zone  = var.pub_availability_zone
  pub_sub_name           = var.pub_sub_name
  pri_subnet_count       = var.pri_subnet_count
  pri_cidr_block         = var.pri_cidr_block
  pri_availability_zone  = var.pri_availability_zone
  pri_sub_name           = var.pri_sub_name
  public_rt_name         = var.public_rt_name
  private_rt_name        = var.private_rt_name
  eip_name               = var.eip_name
  ngw_name               = var.ngw_name
}

module "iam" {
  source = "./modules/iam"
}

module "eks" {
  source                      = "./modules/eks"
  env                         = var.env
  aws_region                  = var.aws_region
  cluster_name                = var.cluster_name
  cluster_version             = var.cluster_version
  endpoint_private_access     = var.endpoint_private_access
  endpoint_public_access      = var.endpoint_public_access
  cluster_role_arn            = module.iam.eks_cluster_role_arn
  node_group_role_arn         = module.iam.node_group_role_arn
  private_subnet_ids          = module.vpc.private_subnet_ids
  ondemand_instance_types     = var.ondemand_instance_types
  spot_instance_types         = var.spot_instance_types
  desired_capacity_on_demand  = var.desired_capacity_on_demand
  min_capacity_on_demand      = var.min_capacity_on_demand
  max_capacity_on_demand      = var.max_capacity_on_demand
  desired_capacity_spot       = var.desired_capacity_spot
  min_capacity_spot           = var.min_capacity_spot
  max_capacity_spot           = var.max_capacity_spot
}

module "bastion" {
  source                   = "./modules/bastion"
  aws_region               = var.aws_region
  cluster_name             = var.cluster_name
  cluster_version          = var.cluster_version
  public_subnet_ids        = module.vpc.public_subnet_ids
  vpc_id                   = module.vpc.vpc_id
  bastion_key_pair_name    = var.bastion_key_pair_name
  bastion_instance_profile = module.iam.bastion_instance_profile
}

module "eks_addons" {
  source       = "./modules/eks_addons"
  cluster_name = var.cluster_name
  addons       = var.addons
}
