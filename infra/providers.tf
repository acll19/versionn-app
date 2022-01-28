# Configure the AWS Provider using Shared Credentials File 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared-credentials-file
provider "aws" {
  region = var.region
  shared_credentials_file = "./credentials"
  profile = var.aws_profile
}