variable "region" {
  description = "AWS region"
  default = "us-east-2"
}

variable "aws_profile" {
  description = "AWS profile"
  default = "default"
}

variable "app_prefix" {
  description = "Application prefix for the AWS services that are built"
  default = "versionn-app"
}