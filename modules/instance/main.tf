# Instance
resource "aws_instance" "instance" {
  depends_on = [aws_security_group.instance-sg]

  count = var.instance-count

  ami             = var.instance-ami-list[count.index]
  instance_type   = var.instance-type-list[count.index]
  subnet_id       = var.instance-sub-id-list[count.index]
  key_name        = var.instance-key-name-list[count.index]
  security_groups = [aws_security_group.instance-sg[count.index].id]

  associate_public_ip_address = var.instance-pub-ip-usage-list[count.index]

  tags = {
    Name = "${var.env}-${var.naming}-${var.instance-name-list[count.index]}-${count.index}"
  }
}


# Security Group
resource "aws_security_group" "instance-sg" {
  count  = var.instance-count
  vpc_id = var.vpc-id
  name   = "${var.env}-${var.naming}-${var.instance-name-list[count.index]}-sg-${count.index}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.naming}-${var.instance-name-list[count.index]}-sg-${count.index}"
  }
}


