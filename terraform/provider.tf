terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
  }

  backend "s3" {
    bucket         = "tf-bucket-ex"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  # Configuration options
}
