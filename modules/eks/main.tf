module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

  cluster_endpoint_private_access = var.endpoint_private_access
  cluster_endpoint_public_access  = var.endpoint_public_access

  eks_managed_node_groups = {
    ondemand = {
      instance_types = var.ondemand_instance_types
      min_size       = var.min_capacity_on_demand
      max_size       = var.max_capacity_on_demand
      desired_size   = var.desired_capacity_on_demand
      iam_role_arn   = var.eks_node_group_role_arn
    }
    spot = {
      capacity_type  = "SPOT"
      instance_types = var.spot_instance_types
      min_size       = var.min_capacity_spot
      max_size       = var.max_capacity_spot
      desired_size   = var.desired_capacity_spot
      iam_role_arn   = var.eks_node_group_role_arn
    }
  }

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = var.eks_node_group_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = var.bastion_role_arn
      username = "bastion"
      groups   = ["system:masters"]
    }
  ]

  tags = {
    Environment = var.env
  }
}
