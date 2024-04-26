resource "aws_security_group" "k8s_master_sg" {
  name   = "${var.env}-k8s-master-sg"
  vpc_id = var.vpc-id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-k8s-master-sg"
  }
}

resource "aws_security_group_rule" "k8s_master_sg_rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.k8s_node_sg.id
  security_group_id        = aws_security_group.k8s_master_sg.id
}

resource "aws_security_group" "k8s_node_sg" {
  name   = "${var.env}-k8s-node-sg"
  vpc_id = var.vpc-id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.k8s_master_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-k8s-node-sg"
  }
}

resource "aws_instance" "k8s_master" {
  ami             = var.k8s-master-ami
  instance_type   = var.k8s-master-type
  subnet_id       = var.pvt-sub-ids[0]
  private_ip      = cidrhost(var.pvt-sub-cidr-blocks[0], 10)
  key_name        = var.k8s-key-name
  security_groups = [aws_security_group.k8s_master_sg.id]

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "${var.env}-k8s-master"
  }
}

resource "aws_instance" "k8s_node" {
  count           = 0
  ami             = var.k8s-master-ami
  instance_type   = var.k8s-master-type
  subnet_id       = var.pvt-sub-ids[0]
  key_name        = var.k8s-key-name
  security_groups = [aws_security_group.k8s_master_sg.id]

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "${var.env}-k8s-node"
  }
}

resource "aws_launch_template" "k8s_node_tpl" {
  # count = 1 or 0
  depends_on    = [aws_instance.k8s_master]
  name_prefix   = "${var.env}-k8s-node-"
  image_id      = var.k8s-node-ami
  instance_type = var.k8s-node-type
  key_name      = var.k8s-key-name

  vpc_security_group_ids = [aws_security_group.k8s_node_sg.id]

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo kubeadm join ${aws_instance.k8s_master.private_ip}:6443 --token uktdln.ar1m1n0z97gvm31o --discovery-token-ca-cert-hash sha256:bcd1d4f9c89ad4f95c3b9f590b8c2184c731d4b86bc16b6fa9d756bf41d123b9
    EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-k8s-asg-instance-tpl"
    }
  }
}

resource "aws_autoscaling_group" "k8s_node_asg" {
  # count = 1 or 0
  launch_template {
    id      = aws_launch_template.k8s_node_tpl.id
    version = "$Latest"
  }

  min_size            = var.k8s-node-asg-min
  max_size            = var.k8s-node-asg-max
  desired_capacity    = var.k8s-node-asg-desired
  vpc_zone_identifier = var.pvt-sub-ids
  target_group_arns   = [var.k8s-service-tg-80]

  tag {
    key                 = "Name"
    value               = "${var.env}-k8s-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  name        = "cpu-scaling-policy"
  policy_type = "TargetTrackingScaling"

  autoscaling_group_name = aws_autoscaling_group.k8s_node_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70
  }
}
