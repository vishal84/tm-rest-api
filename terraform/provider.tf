terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA45GHD7Q466JDPCSC"
  secret_key = "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"
}
