
terraform {
    backend "s3" {
        bucket = "tfstates.gammalab.net"
        key    = "tfportal.tfstate"
        region = "ap-northeast-1"
    }
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.46"
        }
    }
    required_version = ">= 0.14.9"
}

provider "aws" {
    region = "ap-northeast-1"
}

variable "acm_certificate_arm" {}

