output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
