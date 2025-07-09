resource "aws_eks_node_group" "ondemand" {
  cluster_name    = var.cluster_name
  node_group_name = "ng-ondemand"
  node_role_arn   = "" # Replace with your role ARN if IRSA is used

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = tonumber(var.desired_capacity_on_demand)
    min_size     = tonumber(var.min_capacity_on_demand)
    max_size     = tonumber(var.max_capacity_on_demand)
  }

  instance_types = var.ondemand_instance_types

  tags = {
    Name = "ng-ondemand"
  }
}

resource "aws_eks_node_group" "spot" {
  cluster_name    = var.cluster_name
  node_group_name = "ng-spot"
  node_role_arn   = "" # Replace with your role ARN if IRSA is used

  subnet_ids = var.private_subnet_ids

  scaling_config {
    desired_size = tonumber(var.desired_capacity_spot)
    min_size     = tonumber(var.min_capacity_spot)
    max_size     = tonumber(var.max_capacity_spot)
  }

  instance_types = var.spot_instance_types
  capacity_type  = "SPOT"

  tags = {
    Name = "ng-spot"
  }
}
