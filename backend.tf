terraform {
  required_version = ">= 1.1.0"
  required_providers {
    aws = ">= 4.0"
  }

  backend "s3" {
    bucket = "kassio99-terraform-curso"
    key    = "test-terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  profile                  = "default"
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = "us-east-2"
}
