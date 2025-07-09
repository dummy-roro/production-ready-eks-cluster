provider "aws" {
  region = var.aws-region
}

module "vpc" {
  source = "./modules/vpc"
  # uses variables from var.*
}

module "bastion" {
  source = "./modules/bastion"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  key_pair_name    = var.bastion_key_pair_name
  env              = var.env
}

module "eks" {
  source                  = "./modules/eks"
  cluster_name            = var.cluster-name
  cluster_version         = var.cluster-version
  private_subnet_ids      = module.vpc.private_subnet_ids
  endpoint_private_access = var.endpoint-private-access
  endpoint_public_access  = var.endpoint-public-access
  eks_security_group_name = var.eks-sg
}

module "nodegroups" {
  source                         = "./modules/nodegroups"
  cluster_name                   = var.cluster-name
  private_subnet_ids             = module.vpc.private_subnet_ids
  ondemand_instance_types        = var.ondemand_instance_types
  desired_capacity_on_demand     = var.desired_capacity_on_demand
  min_capacity_on_demand         = var.min_capacity_on_demand
  max_capacity_on_demand         = var.max_capacity_on_demand
  spot_instance_types            = var.spot_instance_types
  desired_capacity_spot          = var.desired_capacity_spot
  min_capacity_spot              = var.min_capacity_spot
  max_capacity_spot              = var.max_capacity_spot
}

resource "aws_eks_addon" "eks_addons" {
  for_each = { for addon in var.addons : addon.name => addon }

  cluster_name  = var.cluster-name
  addon_name    = each.value.name
  addon_version = each.value.version
}
