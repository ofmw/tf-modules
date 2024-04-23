resource "aws_security_group" "cloud_bastion_sg" {
  name   = "cloud-bastion-sg"
  vpc_id = var.vpc-id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my-ip]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud-bastion-sg"
  }
}

resource "aws_security_group" "grafana_server_sg" {
  name   = "grafana-server-sg"
  vpc_id = var.vpc-id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.cloud-bastion-sg.id]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.k8s-alb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "grafana-server-sg"
  }
}

# Instance
resource "aws_instance" "cloud_bastion" {
  ami             = var.bastion-ami
  instance_type   = var.bastion-type
  subnet_id       = var.pub-sub-cidr[0].id
  key_name        = var.key-name
  security_groups = [aws_security_group.cloud_bastion_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "cloud-bastion"
  }
}

resource "aws_instance" "grafana_server" {
  depends_on      = var.grafana-depends-on
  ami             = var.grafana-ami
  instance_type   = var.grafana-type
  subnet_id       = var.pvt-sub-app[0].id
  key_name        = var.key-name
  security_groups = [aws_security_group.grafana_server_sg.id]

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "grafana-server"
  }
}
