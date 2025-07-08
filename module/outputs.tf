output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS cluster's Kubernetes API server."
  value       = aws_eks_cluster.this.endpoint
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC provider for IRSA."
  value       = aws_iam_openid_connect_provider.this.arn
}
