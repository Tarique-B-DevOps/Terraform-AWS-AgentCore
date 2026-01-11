terraform {
  required_version = ">=1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.28.0"
    }
  }
  backend "local" {
    path = "STATE/terraform.tfstate"

  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}