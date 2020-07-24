resource "aws_lb" "mysql_nlb" {
  name               = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-mysql-nlb" : "${var.application_name}-mysql-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = {
    Name = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-mysql-nlb" : "${var.application_name}-mysql-nlb"
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
