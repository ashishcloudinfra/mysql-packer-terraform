terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    acl    = "bucket-owner-full-control"
    bucket = "terraform-backend-statefile"
    key    = "mysql/terraform.tfstate"
    region = "ap-south-1"
  }
}
