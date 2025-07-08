locals {
  org = "solaraTek"
  tags = {
    Organization = local.org
    Environment  = var.env
  }
}

module "eks_cluster" {
  source = "./module"

  # Pass all variables to the module
  env                       = var.env
  aws_region                = var.aws_region
  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnets            = var.public_subnets
  private_subnets           = var.private_subnets
  node_groups               = var.node_groups
  addons                    = var.addons
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access    = var.endpoint_public_access
  trusted_security_group_id = var.trusted_security_group_id
  tags                      = local.tags
}
