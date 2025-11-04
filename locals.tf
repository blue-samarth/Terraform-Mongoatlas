data "aws_availability_zones" "available" {}

locals {
  org_short_name = "myorg"
  org_id         = "your_organization_id_here"
  region         = "us-east-1"
  provider_name  = "AWS"
  mongo_org_id   = "THE_MONGODB_ORG_ID"

  vpc_cidr              = "10.10.0.0/16"
  secondary_cidr_blocks = ["10.11.0.0/18", "10.12.0.0/18"]
  azs                   = slice(data.aws_availability_zones.available.names, 0, 3)

  endpoint_service_id_development = "your_endpoint_service_id_here"
  endpoint_service_id_staging     = "your_endpoint_service_id_here"
  endpoint_service_id_production  = "your_endpoint_service_id_here"
}