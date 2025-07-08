# Terraform EKS Private Cluster with Bastion Host

[![Terraform](https://img.shields.io/badge/Terraform-IaC-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![EKS](https://img.shields.io/badge/EKS-Kubernetes-blue?logo=amazon-eks&logoColor=white)](https://aws.amazon.com/eks/)

## Overview

This Terraform project provisions a **private Amazon EKS cluster** with a **bastion host** for secure access. It uses a **modular architecture** to cleanly separate infrastructure components like VPC, IAM, EKS, and Bastion.

## 📂 Project Structure

```
production-ready-eks-cluster/
├── main.tf                 # Root Terraform config
├── variables.tf            # Input variables
├── outputs.tf              # Outputs for reference
├── dev.tfvars              # Dev environment values
│
├── modules/
│   ├── vpc/                # VPC, Subnets, IGW, NAT, Routing
│   ├── bastion/            # Bastion EC2 instance + SSM
│   ├── eks/                # EKS Cluster, Node Groups, aws-auth
│   └── iam/                # IAM Roles for EKS + Bastion
└── README.md
```

## 🔧 Prerequisites

- Terraform >= 1.32
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

This is a **private EKS cluster**, so access is granted via a **bastion host**.

### ✅ Option 1: AWS Systems Manager (Recommended)

Use SSM Session Manager to connect:

```bash
aws ssm start-session --target <instance-id>
```

Or

EC2 connect via SSM in AWS console.


### ✅ Option 2: SSH (Fallback)

Ensure port 22 is open and your IP is whitelisted in security group.

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
  ...
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
