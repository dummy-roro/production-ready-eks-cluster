# ---------------------------------
# IAM Role for the EKS Cluster
# ---------------------------------
resource "aws_iam_role" "cluster" {
  count = var.is_eks_cluster_enabled ? 1 : 0
  name  = "${var.env}-${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  count      = var.is_eks_cluster_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster[0].name
}


# ---------------------------------
# IAM Role for the EKS Node Groups
# ---------------------------------
resource "aws_iam_role" "node" {
  count = var.is_eks_cluster_enabled ? 1 : 0
  name  = "${var.env}-${var.cluster_name}-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "node_worker_policy" {
  count      = var.is_eks_cluster_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node_cni_policy" {
  count      = var.is_eks_cluster_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node_registry_policy" {
  count      = var.is_eks_cluster_enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node[0].name
}


# ---------------------------------
# IAM Role for the Jump Host
# ---------------------------------
resource "aws_iam_role" "jump_host" {
  name = "${var.env}-jump-host-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  # This inline policy grants the jump host permission to describe EKS clusters
  # which is required for the `aws eks update-kubeconfig` command.
  inline_policy {
    name = "eks-describe-clusters"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action   = ["eks:DescribeCluster"],
          Effect   = "Allow",
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "jump_host" {
  name = "${var.env}-jump-host-profile"
  role = aws_iam_role.jump_host.name
}
