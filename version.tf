terraform {
  required_version = ">1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.19.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.1.0"
    }
  }
}