#!/bin/bash
set -e

yum update -y

# AWS CLI v2
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

# Install kubectl for EKS
CLUSTER_VERSION="1.32"
curl -sLO "https://dl.k8s.io/release/v${CLUSTER_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Auto-generate kubeconfig for cluster access
REGION="us-east-1"
CLUSTER_NAME="eks-cluster"
aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME"

echo "✅ Bastion setup complete. You can now run 'kubectl get nodes'"
