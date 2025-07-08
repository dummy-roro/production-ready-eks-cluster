output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

output "bastion_ssm_role_arn" {
  value = aws_iam_role.bastion_ssm_role.arn
}
