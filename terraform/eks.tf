# EKS Cluster
resource "aws_eks_cluster" "main" {
  count    = var.is_eks_cluster_enabled ? 1 : 0
  name     = "${var.env}-${var.cluster_name}"
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster[0].arn

  vpc_config {
    subnet_ids              = aws_subnet.private[*].id
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [aws_security_group.eks_control_plane[0].id]
  }

  access_config {
    authentication_mode                       = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Name = var.cluster_name
    Env  = var.env
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
  ]
}

# EKS Addons
resource "aws_eks_addon" "main" {
  # Using a robust for_each with the addon name as the key
  for_each     = { for addon in var.addons : addon.name => addon if var.is_eks_cluster_enabled }
  cluster_name = aws_eks_cluster.main[0].name
  addon_name   = each.value.name
  addon_version = each.value.version

  depends_on = [
    aws_eks_node_group.on_demand,
    aws_eks_node_group.spot
  ]
}

# EKS Node Group - On Demand
resource "aws_eks_node_group" "on_demand" {
  count                  = var.is_eks_cluster_enabled ? 1 : 0
  cluster_name           = aws_eks_cluster.main[0].name
  node_group_name        = "${var.env}-${var.cluster_name}-ondemand"
  node_role_arn          = aws_iam_role.node[0].arn
  subnet_ids             = aws_subnet.private[*].id
  instance_types         = var.ondemand_instance_types
  capacity_type          = "ON_DEMAND"
  vpc_security_group_ids = [aws_security_group.eks_nodes[0].id]

  scaling_config {
    desired_size = var.desired_capacity_on_demand
    min_size     = var.min_capacity_on_demand
    max_size     = var.max_capacity_on_demand
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    "ondemand" = "true"
  }

  tags = {
    Name = "${var.env}-${var.cluster_name}-ondemand-nodes"
  }
}

# EKS Node Group - Spot
resource "aws_eks_node_group" "spot" {
  count                  = var.is_eks_cluster_enabled ? 1 : 0
  cluster_name           = aws_eks_cluster.main[0].name
  node_group_name        = "${var.env}-${var.cluster_name}-spot"
  node_role_arn          = aws_iam_role.node[0].arn
  subnet_ids             = aws_subnet.private[*].id
  instance_types         = var.spot_instance_types
  capacity_type          = "SPOT"
  vpc_security_group_ids = [aws_security_group.eks_nodes[0].id]
  disk_size              = 50

  scaling_config {
    desired_size = var.desired_capacity_spot
    min_size     = var.min_capacity_spot
    max_size     = var.max_capacity_spot
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    "spot" = "true"
  }

  tags = {
    Name = "${var.env}-${var.cluster_name}-spot-nodes"
  }
}
