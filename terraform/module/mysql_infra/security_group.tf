resource "aws_security_group" "module_sg" {
  count = var.security_group_ids == null ? 1 : 0

  name        = "${var.name_prefix}-${var.application_name}-prometheus-sg"
  description = "Default security group created by terraform"
  vpc_id      = var.vpc_id

  # Rules
  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-${var.application_name}-prometheus-sg"
  }
}
