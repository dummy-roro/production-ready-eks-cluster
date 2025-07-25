output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "node_group_role_arn" {
  value = aws_iam_role.node_group_role.arn
}

output "bastion_instance_profile" {
  value = aws_iam_instance_profile.bastion_instance_profile.name
}
