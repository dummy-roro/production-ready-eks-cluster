env                   = "prod"
aws-region            = "ap-southeast-1"
vpc-cidr-block        = "10.16.0.0/16"
vpc-name              = "vpc"
igw-name              = "igw"
pub-subnet-count      = 2
pub-cidr-block        = ["10.16.0.0/20", "10.16.16.0/20"]
pub-availability-zone = ["ap-southeast-1a", "ap-southeast-1b"]
pub-sub-name          = "subnet-public"
pri-subnet-count      = 2
pri-cidr-block        = ["10.16.128.0/20", "10.16.144.0/20"]
pri-availability-zone = ["ap-southeast-1a", "ap-southeast-1b"]
pri-sub-name          = "subnet-private"
public-rt-name        = "public-route-table"
private-rt-name       = "private-route-table"
eip-name              = "elasticip-ngw"
ngw-name              = "ngw"
eks-sg                = "eks-sg"

# EKS
is-eks-cluster-enabled     = true
cluster-version            = "1.32"          # have to change as k8s' version
cluster-name               = "eks-cluster"   # change name of cluster as per requirement
endpoint-private-access    = true
endpoint-public-access     = false
ondemand_instance_types    = ["m5a.large"]
spot_instance_types        = ["t3a.medium"]  # Add "c5a.large" (optional)
desired_capacity_on_demand = "2"
min_capacity_on_demand     = "2"
max_capacity_on_demand     = "5"
desired_capacity_spot      = "2"
min_capacity_spot          = "2"
max_capacity_spot          = "10"
addons = [
  {
    name    = "vpc-cni",
    version = "v1.19.2-eksbuild.1"
  },
  {
    name    = "coredns"
    version = "v1.11.4-eksbuild.1"
  },
  {
    name    = "kube-proxy"
    version = "v1.31.3-eksbuild.2"
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.38.1-eksbuild.1"
  }
  # Add more addons as needed
]
