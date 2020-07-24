provider aws {
  region = var.aws_region
  #profile = "ashishb"
}

module "mysql_infra" {
  source = "../../module/mysql_infra"

  aws_region           = var.aws_region
  name_prefix          = var.environment
  environment          = var.environment
  application_name     = var.application_name
  vpc_id               = "vpc-0a3f9185b2c4191ac"
  subnet_ids           = ["subnet-0f929b8fbd4a86d64", "subnet-08265c1306cadf5f2"]
  ec2_instance_type    = "t2.micro"
  asg_desired_capacity = 0
}
