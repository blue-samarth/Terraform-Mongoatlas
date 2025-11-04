terraform {
  required_version = ">1.13.0"

  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "2.1.0"
    }
  }
}