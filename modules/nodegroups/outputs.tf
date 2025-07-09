output "nodegroup_ondemand_name" {
  value = aws_eks_node_group.ondemand.node_group_name
}

output "nodegroup_spot_name" {
  value = aws_eks_node_group.spot.node_group_name
}
