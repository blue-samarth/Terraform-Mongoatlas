data "aws_availability_zones" "available" {}

locals {
  org_short_name = "myorg"
  org_id         = "Enter_your_aws_org_id_here"
  region         = "ap-south-1"
  provider_name  = "AWS"
  mongo_org_id   = "ENTER_YOUR_MONGO_ORG_ID_HERE"

  vpc_cidr              = "10.10.0.0/16"
  secondary_cidr_blocks = ["10.11.0.0/21", "10.12.0.0/21"]
  azs                   = slice(data.aws_availability_zones.available.names, 0, 3)

}