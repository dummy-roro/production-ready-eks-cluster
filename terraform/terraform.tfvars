# ---------------------------------
# Environment and AWS Configuration
# ---------------------------------
env        = "dev"
aws_region = "us-east-1"


# ---------------------------------
# VPC Networking Configuration
# ---------------------------------
vpc_cidr_block        = "10.16.0.0/16"
vpc_name              = "eks-vpc"
pub_subnet_count      = 3
pub_cidr_block        = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
pub_availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
pri_subnet_count      = 3
pri_cidr_block        = ["10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20"]
pri_availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]


# ---------------------------------
# Jump Host Configuration
# ---------------------------------
# The name of the AWS EC2 Key Pair you have created for SSH access.
jump_host_ssh_key_name = "your-aws-key-name"

# Your current public IP address to allow SSH access. Find it by searching "what is my IP".
jump_host_allowed_ip = "1.2.3.4/32"


# ---------------------------------
# EKS Cluster Configuration
# ---------------------------------
is_eks_cluster_enabled  = true
cluster_name            = "eks-cluster"
cluster_version         = "1.32" # Using a valid, recent version
endpoint_private_access = true
endpoint_public_access  = false


# ---------------------------------
# EKS Node Group Configuration
# ---------------------------------
ondemand_instance_types      = ["t3.medium"]
desired_capacity_on_demand = "1"
min_capacity_on_demand     = "1"
max_capacity_on_demand     = "3"

spot_instance_types      = ["t3.medium", "t3a.medium"]
desired_capacity_spot    = "2"
min_capacity_spot        = "1"
max_capacity_spot        = "5"


# ---------------------------------
# EKS Addons Configuration
# ---------------------------------
# Use versions compatible with your cluster_version (1.28)
addons = [
  {
    name    = "vpc-cni",
    version = "v1.18.1-eksbuild.1"
  },
  {
    name    = "coredns",
    version = "v1.10.1-eksbuild.1"
  },
  {
    name    = "kube-proxy",
    version = "v1.28.5-eksbuild.1"
  },
  {
    name    = "aws-ebs-csi-driver",
    version = "v1.28.0-eksbuild.1"
  }
]
