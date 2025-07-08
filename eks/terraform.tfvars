# General Settings
env          = "dev"
aws_region   = "ap-southeast-1"
cluster_name = "solara-cluster"

# VPC Configuration
vpc_cidr_block = "10.16.0.0/16"

# Define your public and private subnets as a list of objects.
# The module will create as many as you define here.
public_subnets = [
  { az = "ap-southeast-1a", cidr = "10.16.0.0/20" },
  { az = "ap-southeast-1b", cidr = "10.16.16.0/20" },
  { az = "ap-southeast-1c", cidr = "10.16.32.0/20" },
]

private_subnets = [
  { az = "ap-southeast-1a", cidr = "10.16.128.0/20" },
  { az = "ap-southeast-1b", cidr = "10.16.144.0/20" },
  { az = "ap-southeast-1c", cidr = "10.16.160.0/20" },
]

# EKS Cluster Settings
cluster_version           = "1.32"
endpoint_private_access   = true
endpoint_public_access    = false # Set to true if you need public access
trusted_security_group_id = "sg-0123456789abcdef" # IMPORTANT: The ID of a security group that can access the cluster's private endpoint

# Define one or more EKS managed node groups.
# The key for each group (e.g., "ondemand_t3") becomes part of its name.
node_groups = {
  ondemand_t3 = {
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
    min_size       = 1
    max_size       = 5
    desired_size   = 1
  },
  spot_t3 = {
    instance_types = ["t3.large", "t3a.large"]
    capacity_type  = "SPOT"
    min_size       = 2
    max_size       = 10
    desired_size   = 2
  }
}

# EKS Add-ons - ensure versions are compatible with your cluster_version
addons = [
  { name = "vpc-cni", version = "v1.16.3-eksbuild.1" },
  { name = "coredns", version = "v1.10.1-eksbuild.7" },
  { name = "kube-proxy", version = "v1.29.0-eksbuild.1" },
  { name = "aws-ebs-csi-driver", version = "v1.28.0-eksbuild.1" }
]
