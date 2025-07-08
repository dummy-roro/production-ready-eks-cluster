locals {
  name_prefix = "${var.cluster_name}-${var.env}"
}

resource "aws_eks_cluster" "this" {
  name     = local.name_prefix
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = values(aws_subnet.private)[*].id
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [aws_security_group.cluster.id]
  }

  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}

# OIDC Provider for IAM Roles for Service Accounts (IRSA)
resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [] # AWS Provider automatically handles this now
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = var.tags
}

# EKS Add-ons
resource "aws_eks_addon" "this" {
  for_each = { for addon in var.addons : addon.name => addon }

  cluster_name  = aws_eks_cluster.this.name
  addon_name    = each.key
  addon_version = each.value.version
}

# EKS Managed Node Groups
resource "aws_eks_node_group" "this" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.name_prefix}-ng-${each.key}"
  node_role_arn   = aws_iam_role.nodegroup.arn
  subnet_ids      = values(aws_subnet.private)[*].id

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

  scaling_config {
    min_size     = each.value.min_size
    max_size     = each.value.max_size
    desired_size = each.value.desired_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(var.tags, {
    Name = "${local.name_prefix}-ng-${each.key}"
  })

  depends_on = [
    aws_iam_role_policy_attachment.nodegroup_worker_policy,
    aws_iam_role_policy_attachment.nodegroup_cni_policy,
    aws_iam_role_policy_attachment.nodegroup_ecr_readonly_policy,
  ]
}
