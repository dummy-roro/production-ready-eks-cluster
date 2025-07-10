data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for Bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_ids[0]
  key_name                    = var.bastion_key_pair_name
  associate_public_ip_address = true
  iam_instance_profile        = var.bastion_instance_profile
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y curl unzip amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent

    curl -o kubectl https://amazon-eks.s3.${var.aws_region}.amazonaws.com/${var.cluster_version}/2023-12-22/bin/linux/amd64/kubectl
    chmod +x kubectl
    mv kubectl /usr/local/bin/

    aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}
  EOF

  tags = {
    Name = "eks-bastion"
  }
}
