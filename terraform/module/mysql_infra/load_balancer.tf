resource "aws_lb" "mysql_nlb" {
  name               = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-mysql-nlb" : "${var.application_name}-mysql-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = {
    Name = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-mysql-nlb" : "${var.application_name}-mysql-nlb"
  }
}


resource "aws_lb" "grafana_alb" {
  name               = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-grafana-alb" : "${var.application_name}-grafana-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids != null ? var.security_group_ids : aws_security_group.module_sg.*.id
  subnets            = var.subnet_ids

  tags = {
    Name = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-prometheus-nlb" : "${var.application_name}-prometheus-nlb"
  }
}

resource "aws_lb_listener" "prometheus_listner" {
  load_balancer_arn = aws_lb.grafana_alb.arn
  port              = 9090
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_tg.arn
  }
}
resource "aws_lb_listener" "grafana_listner" {
  load_balancer_arn = aws_lb.grafana_alb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}
resource "aws_lb_listener" "mysql_listner" {
  load_balancer_arn = aws_lb.mysql_nlb.arn
  port              = 3306
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mysql_tg.arn
  }
}
resource "aws_lb_target_group" "mysql_tg" {
  name     = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-mysql-tg" : "${var.application_name}-mysql-tg"
  port     = 3306
  protocol = "TCP"
  vpc_id   = var.vpc_id
}
resource "aws_lb_target_group" "prometheus_tg" {
  name                 = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-prometheus-tg" : "${var.application_name}-prometheus-tg"
  port                 = 9090
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 60

  health_check {
    enabled             = true
    interval            = 10
    path                = ""
    port                = 9090
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}
resource "aws_lb_target_group" "grafana_tg" {
  name                 = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-grafana-tg" : "${var.application_name}-grafana-tg"
  port                 = 3000
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 60

  health_check {
    enabled             = true
    interval            = 10
    path                = ""
    port                = 3000
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}
