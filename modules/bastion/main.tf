resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  key_name               = var.bastion_key_pair
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name

  tags = {
    Name = "bastion"
  }
}

resource "aws_iam_instance_profile" "this" {
  name = "bastion-instance-profile"
  role = var.bastion_role_arn
}
