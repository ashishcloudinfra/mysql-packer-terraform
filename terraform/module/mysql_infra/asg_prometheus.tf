data "aws_ami" "prometheus" {
  most_recent = true

  filter {
    name   = "tag:Name"
    values = ["prometheus-AMI"]
  }
  filter {
    name   = "tag:Description"
    values = ["Created by Packer"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }

  owners = ["self"]
}

resource "aws_launch_configuration" "grafana_lc" {
  name_prefix          = var.name_prefix != null ? "${var.name_prefix}-grafana-lc-" : null
  image_id             = data.aws_ami.mysql.id
  instance_type        = var.ec2_instance_type
  key_name             = var.ec2_keypair != null ? var.ec2_keypair : null
  security_groups      = var.security_group_ids != null ? var.security_group_ids : aws_security_group.module_sg.*.id
  iam_instance_profile = var.ec2_instance_profile != null ? var.ec2_instance_profile : null

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "grafana_asg" {
  name = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-grafana-asg" : "${var.application_name}-grafana-asg"

  max_size                  = 1
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.grafana_lc.name
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [aws_lb_target_group.prometheus_tg.arn, aws_lb_target_group.grafana_tg.arn]

  tag {
    key                 = "Name"
    value               = var.name_prefix != null ? "${var.name_prefix}-${var.application_name}-grafana-asg" : "${var.application_name}-grafana-asg"
    propagate_at_launch = true
  }

}
