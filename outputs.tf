output "vpc_id" {
  value = module.vpc.vpc_id
}

output "bastion_ip" {
  value = module.bastion.public_ip
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
