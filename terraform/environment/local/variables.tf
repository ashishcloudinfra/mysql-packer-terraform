variable aws_region {
  type        = string
  description = "AWS Region"
  default     = "ap-south-1"
}
variable environment {
  type        = string
  description = "Name of the environment"
  default     = "local"
}
variable application_name {
  type        = string
  description = "Name of the application"
  default     = "test"
}
