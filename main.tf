provider "aws" {
  region = var.aws-region
}

module "iam" {
  source = "./modules/iam"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr           = var.vpc-cidr-block
  vpc_name           = var.vpc-name
  igw_name           = var.igw-name
  eip_name           = var.eip-name
  ngw_name           = var.ngw-name
  pub_subnet_count   = var.pub-subnet-count
  pub_cidr_block     = var.pub-cidr-block
  pub_azs            = var.pub-availability-zone
  pub_sub_name       = var.pub-sub-name
  pri_subnet_count   = var.pri-subnet-count
  pri_cidr_block     = var.pri-cidr-block
  pri_azs            = var.pri-availability-zone
  pri_sub_name       = var.pri-sub-name
  public_rt_name     = var.public-rt-name
  private_rt_name    = var.private-rt-name
}

module "bastion" {
  source              = "./modules/bastion"
  vpc_id              = module.vpc.vpc_id
  public_subnet_id    = module.vpc.public_subnets[0]
  bastion_key_pair    = var.bastion_key_pair_name
  bastion_role_arn    = module.iam.bastion_ssm_role_arn
}

module "eks" {
  source                         = "./modules/eks"
  vpc_id                         = module.vpc.vpc_id
  private_subnet_ids             = module.vpc.private_subnets
  cluster_name                   = var.cluster-name
  cluster_version                = var.cluster-version
  endpoint_private_access        = var.endpoint-private-access
  endpoint_public_access         = var.endpoint-public-access
  ondemand_instance_types        = var.ondemand_instance_types
  spot_instance_types            = var.spot_instance_types
  desired_capacity_on_demand     = var.desired_capacity_on_demand
  min_capacity_on_demand         = var.min_capacity_on_demand
  max_capacity_on_demand         = var.max_capacity_on_demand
  desired_capacity_spot          = var.desired_capacity_spot
  min_capacity_spot              = var.min_capacity_spot
  max_capacity_spot              = var.max_capacity_spot
  eks_node_group_role_arn        = module.iam.eks_node_group_role_arn
  bastion_role_arn               = module.iam.bastion_ssm_role_arn
  addons                         = var.addons
  env                            = var.env
}
