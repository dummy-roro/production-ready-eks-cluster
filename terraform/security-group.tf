# 1. Security Group for the Jump Host
resource "aws_security_group" "jump_host" {
  name        = "${var.env}-jump-host-sg"
  description = "Allow SSH from a specific IP to the Jump Host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.jump_host_allowed_ip]  #change as per requirement
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-jump-host-sg"
  }
}

# 2. Security Group for the EKS Control Plane
resource "aws_security_group" "eks_control_plane" {
  count       = var.is_eks_cluster_enabled ? 1 : 0
  name        = "${var.env}-eks-control-plane-sg"
  description = "EKS control plane security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.env}-eks-control-plane-sg"
  }
}

# 3. Security Group for the EKS Worker Nodes
resource "aws_security_group" "eks_nodes" {
  count       = var.is_eks_cluster_enabled ? 1 : 0
  name        = "${var.env}-eks-node-sg"
  description = "Security group for all EKS nodes"
  vpc_id      = aws_vpc.main.id

  # Allow nodes to communicate with each other
  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-eks-node-sg"
  }
}

# --- Rules to connect the security groups ---

# Allow Jump Host to talk to EKS Control Plane on port 443 (for kubectl)
resource "aws_security_group_rule" "jump_to_control_plane" {
  count                    = var.is_eks_cluster_enabled ? 1 : 0
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_control_plane[0].id
  source_security_group_id = aws_security_group.jump_host.id
  description              = "Allow kubectl from Jump Host"
}

# Allow Nodes to talk to EKS Control Plane
resource "aws_security_group_rule" "nodes_to_control_plane" {
  count                    = var.is_eks_cluster_enabled ? 1 : 0
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_control_plane[0].id
  source_security_group_id = aws_security_group.eks_nodes[0].id
  description              = "Allow nodes to connect to control plane"
}

# Allow Control Plane to talk to Nodes on all ports
resource "aws_security_group_rule" "control_plane_to_nodes" {
  count                    = var.is_eks_cluster_enabled ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes[0].id
  source_security_group_id = aws_security_group.eks_control_plane[0].id
  description              = "Allow control plane to connect to nodes"
}
