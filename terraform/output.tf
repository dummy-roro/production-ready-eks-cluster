output "jump_host_public_ip" {
  description = "Public IP address of the jump host for SSH."
  value       = aws_instance.jump_host.public_ip
}

output "ssh_command_to_jump_host" {
  description = "Example command to SSH into the jump host."
  value       = "ssh -i /path/to/${var.jump_host_ssh_key_name}.pem ec2-user@${aws_instance.jump_host.public_ip}"
}

output "configure_kubectl_command" {
  description = "Run this command on the jump host to configure kubectl for your cluster."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main[0].name}"
}

output "jump_host_iam_role_arn" {
  description = "IAM Role ARN for the jump host. Add this to the aws-auth ConfigMap for kubectl access."
  value       = aws_iam_role.jump_host.arn
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = var.is_eks_cluster_enabled ? aws_eks_cluster.main[0].name : "EKS Cluster not enabled."
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS cluster's Kubernetes API."
  value       = var.is_eks_cluster_enabled ? aws_eks_cluster.main[0].endpoint : "EKS Cluster not enabled."
}
