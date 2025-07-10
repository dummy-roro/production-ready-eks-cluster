# Terraform EKS Private Cluster with Bastion Host

[![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![EKS](https://img.shields.io/badge/EKS-Kubernetes-blue?logo=amazon-eks&logoColor=white)](https://aws.amazon.com/eks/)

## Overview

This Terraform project provisions a **private Amazon EKS cluster** using a **modular architecture**, along with a **bastion host** that provides secure CLI and SSM-based access.

## 📂 Project Structure

```
production-ready-eks-cluster/
├── README.md               # Full Documentation
├── main.tf                 # Root orchestration: wires modules together
├── variables.tf            # Declares root-level variables passed to modules
├── outputs.tf              # Exposes useful outputs (cluster name, IPs)
├── provider.tf             # AWS provider + remote backend config (S3 + DynamoDB)
├── terraform.tfvars        # Your input config (environment, instance types, etc.)
└── modules/
    ├── vpc/
    │   ├── main.tf         # VPC, subnets, route tables, NAT gateway
    │   ├── variables.tf    # VPC-related variables
    │   └── outputs.tf      # VPC outputs: subnet IDs, VPC ID
    ├── iam/
    │   ├── main.tf         # IAM roles, policies, instance profiles
    │   ├── variables.tf    # Node group and Bastion IAM policies
    │   └── outputs.tf      # Role ARNs and Bastion profile
    ├── eks/
    │   ├── main.tf         # EKS cluster, on-demand + spot node groups
    │   ├── variables.tf    # Cluster settings and capacities
    │   └── outputs.tf      # Endpoint, cert authority, cluster name
    ├── bastion/
    │   ├── main.tf         # EC2 Bastion host with kubectl + SSM agent
    │   ├── variables.tf    # Key pair, subnet, instance profile
    │   └── outputs.tf      # Bastion IP, instance ID
    └── eks_addons/
        ├── main.tf         # Installs core EKS add-ons: VPC CNI, CoreDNS, etc.
        ├── variables.tf    # Addon list with version mapping
        └── outputs.tf      # Installed addon names
```

## 🔧 Prerequisites

- Terraform >= 1.3
- AWS CLI configured (`aws configure`)
- Existing EC2 Key Pair name (for Bastion)
- IAM user with privileges to provision VPC, EC2, EKS, IAM, etc.

## 🚀 Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Plan the Deployment

```bash
terraform plan -var-file="terraform.tfvars"
```

### 3. Apply the Configuration

```bash
terraform apply -var-file="terraform.tfvars"
```

## 📡 Accessing the Cluster

| Method                  | How it Works                                                                                 |
|-------------------------|----------------------------------------------------------------------------------------------|
| `SSM`                   | Via IAM Role `aws ssm start-session --target <bastion_instance_id>`                          |
| `SSH`                   | Using EC2 key pair and public IP `ssh -i /path/to/your-key.pem ec2-user@<bastion_public_ip>` |

### Once connected, you're ready to run:

```bash
kubectl get nodes
kubectl cluster-info
```

## 🔐 IAM Roles

| Role                    | Purpose                          | IAM Policies Attached                                |
|-------------------------|----------------------------------|------------------------------------------------------|
| `eks-cluster-role`      | EKS control plane                | `AmazonEKSClusterPolicy`                             |
| `eks-node-group-role`   | Worker node permissions          | `EKSWorkerNode`, `CNI`, `ECR`, `EBS CSI`             |
| `bastion-ssm-role`      | SSM Session Manager access       | `AmazonSSMManagedInstanceCore`                       |

## 🛠 Features

- ✅ Private EKS endpoint
- ✅ Managed Node Groups (On-Demand + Spot)
- ✅ Add-ons: VPC CNI, CoreDNS, kube-proxy, EBS CSI
- ✅ Bastion EC2 with SSM access
- ✅ Modular and reusable code

## 📦 Add-ons

Define add-ons in `terraform.tfvars`:

```hcl
addons = [
  { name = "vpc-cni", version = "v1.19.2-eksbuild.1" },
  { name = "coredns", version = "v1.11.4-eksbuild.1" },
  { name = "kube-proxy", version = "v1.31.3-eksbuild.2" },
  { name = "aws-ebs-csi-driver", version = "v1.38.1-eksbuild.1" }
]
```

## 📤 Outputs

- `bastion_public_ip` – useful if using SSH
- `eks_cluster_name` – reference for tooling

## 🧹 Cleanup

```bash
terraform destroy -var-file="terraform.tfvars"
```

## 📚 References

- [Terraform AWS EKS Module](https://github.com/terraform-aws-modules/terraform-aws-eks)
- [Amazon EKS Docs](https://docs.aws.amazon.com/eks/)
- [Amazon EC2 Bastion Best Practices](https://docs.aws.amazon.com/whitepapers/latest/bastion-hosts/)
