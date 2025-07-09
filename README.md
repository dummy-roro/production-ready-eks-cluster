# Terraform EKS Private Cluster with Bastion Host

[![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![EKS](https://img.shields.io/badge/EKS-Kubernetes-blue?logo=amazon-eks&logoColor=white)](https://aws.amazon.com/eks/)

## Overview

This Terraform project provisions a **private Amazon EKS cluster** using a **modular architecture**, along with a **bastion host** that provides secure CLI and SSM-based access.

## 📂 Project Structure

```
production-ready-eks-cluster/
├── README.md                    # Full documentation
├── backend.tf                   # Remote state config
├── main.tf                      # Module orchestrator
├── variables.tf                 # Input declarations
├── outputs.tf                   # Key outputs
├── terraform.tfvars             # Environment configuration
├── modules/
│   ├── vpc/                     # VPC networking and subnets
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── bastion/                 # Bastion host and security group
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── userdata.sh
│   ├── eks/                     # EKS cluster
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── nodegroups/              # On-demand & spot node groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
└── extras/
    └── irsa.tf                  # IRSA roles for secure pod access (optional)
    

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

| Method                  | How it Works                                                                           |
|-------------------------|----------------------------------------------------------------------------------------|
| `SSM`                   |Via IAM Role `aws ssm start-session`                                                    |
| `SSH`                   | Using EC2 key pair and public IP                                                       |

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
