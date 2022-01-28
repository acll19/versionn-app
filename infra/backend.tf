terraform {
    required_version = "> 1.0.4"

    backend "s3" {
        bucket  = "terraform-backend-versionn-app"
        key     = "versionn-app-state"
        region  = "us-east-2"
        encrypt = true
    }

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 3.53.0"
        }
    }
}