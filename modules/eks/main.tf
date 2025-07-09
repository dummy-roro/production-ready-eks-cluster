module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                     = var.cluster_name
  cluster_version                  = var.cluster_version
  subnet_ids                       = var.private_subnet_ids
  cluster_endpoint_private_access  = var.endpoint_private_access
  cluster_endpoint_public_access   = var.endpoint_public_access
  cluster_security_group_name      = var.eks_security_group_name
}
