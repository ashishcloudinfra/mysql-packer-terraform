variable aws_region {
  type        = string
  description = "AWS Region"
}
variable vpc_id {
  type        = string
  description = "VPC ID"
}

variable name_prefix {
  type        = string
  description = "Name prefix to attach to the resource name"
  default     = null
}
variable application_name {
  type        = string
  description = "Name of the application"
}
variable environment {
  type        = string
  description = "Name of the environment"
}

variable ec2_instance_type {
  type        = string
  description = "EC2 instance type"
}
variable ec2_keypair {
  type        = string
  description = "Name of the EC2 keypair"
  default     = null
}
variable security_group_ids {
  type        = list(string)
  description = "List of Security group ID's"
  default     = null
}
variable subnet_ids {
  type        = list(string)
  description = "List of Subnet ID's"
}
variable ec2_instance_profile {
  type        = string
  description = "ARN of IAM Instance profile"
  default     = null
}
variable asg_desired_capacity {
  type        = number
  description = "Number of desired instances within ASG. Between 0-1"
}
