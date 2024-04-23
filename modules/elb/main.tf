# Target Group

resource "aws_lb_target_group" "k8s_grafana_tg_3000" {
  name     = "k8s-grafana-tg-3000"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "k8s_grafana_target" {
  target_group_arn = aws_lb_target_group.k8s_grafana_tg_3000.arn
  target_id        = var.grafana-server-id
  port             = 3000
}

resource "aws_lb_target_group" "k8s_prometheus_tg_9090" {
  name     = "k8s-prometheus-tg-9090"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "k8s_prometheus_target" {
  target_group_arn = aws_lb_target_group.k8s_prometheus_tg_9090.arn
  target_id        = var.k8s-master-id
  port             = 9090
}

resource "aws_lb_target_group" "onprem_jenkins_tg_8080" {
  name        = "onprem-jenkins-tg-8080"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc-id
  target_type = "ip" # 대상을 IP로 지정하는 경우 Target Type을 명시해주어야한다.

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "onprem_jenkins_target" {
  target_group_arn  = aws_lb_target_group.onprem_jenkins_tg_8080.arn
  target_id         = "192.168.0.202" # On-Premise Jenkins Server Private IP
  port              = 8080
  availability_zone = "all"
}

resource "aws_lb_target_group" "k8s_service_tg_80" {
  name     = "k8s-service-tg-80"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path                = "/api/v1/healthz"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Security Group
resource "aws_security_group" "k8s_alb_sg" {
  name   = "k8s-alb-sg"
  vpc_id = var.vpc-id


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
    Name = "k8s-alb-sg"
  }
}

# Load Balancer

resource "aws_lb" "k8s_monitor_alb" {
  name               = "k8s-monitor-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.k8s_alb_sg.id]
  subnets            = var.pub-sub-id
}

resource "aws_lb_listener" "k8s_grafana_listener_3000" {
  load_balancer_arn = aws_lb.k8s_monitor_alb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_grafana_tg_3000.arn
  }
}

resource "aws_lb_listener" "k8s_prometheus_listener_9090" {
  load_balancer_arn = aws_lb.k8s_monitor_alb.arn
  port              = 9090
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_prometheus_tg_9090.arn
  }
}

resource "aws_lb" "k8s_service_alb" {
  name               = "k8s-service-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.k8s-alb-sg.id]
  subnets            = var.pub-sub-id
}

resource "aws_lb_listener" "k8s_jenkins_listener_8080" {
  load_balancer_arn = aws_lb.k8s_service_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.onprem_jenkins_tg_8080.arn
  }
}

resource "aws_lb_listener" "k8s_service_listener_80" {
  load_balancer_arn = aws_lb.k8s_service_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k8s_service_tg_80.arn
  }
}