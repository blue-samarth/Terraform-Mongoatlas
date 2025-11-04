module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">=6.5.0"

  name                  = "${local.org_short_name}-vpc"
  cidr                  = local.vpc_cidr
  secondary_cidr_blocks = local.secondary_cidr_blocks
  azs                   = local.azs

  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]
  elasticache_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 12)]
  intra_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 16)]

  enable_nat_gateway         = true
  single_nat_gateway         = true
  one_nat_gateway_per_az     = false
  manage_default_network_acl = false
  default_network_acl_tags = {
    Name  = "${local.org_short_name}-default-acl"
    Owner = "Terraform"
    team  = "devops"
  }

  manage_default_route_table = false
  default_route_table_tags = {
    Name  = "${local.org_short_name}-default-rt"
    Owner = "Terraform"
    team  = "devops"
  }

  manage_default_security_group = false
  default_security_group_tags = {
    Name  = "${local.org_short_name}-default-sg"
    Owner = "Terraform"
    team  = "devops"
  }
}

resource "aws_vpc_endpoint" "vpc_mongodb_dev" {
  vpc_id             = module.vpc.vpc_id
  service_name       = mongodbatlas_privatelink_endpoint.privatelink_endpoint_development.endpoint_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.vpc.default_security_group_id]

  auto_accept         = false
  private_dns_enabled = false

  tags = { Name = "${local.org_short_name}-mongodb-dev" }

  lifecycle {
    create_before_destroy = false
  }

  depends_on = [ mongodbatlas_privatelink_endpoint.privatelink_endpoint_development ]
}

resource "aws_vpc_endpoint" "vpc_mongodb_staging" {
  vpc_id             = module.vpc.vpc_id
  service_name       = mongodbatlas_privatelink_endpoint.privatelink_endpoint_staging.endpoint_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.vpc.default_security_group_id]

  auto_accept         = false
  private_dns_enabled = false

  tags = { Name = "${local.org_short_name}-mongodb-staging" }
  lifecycle {
    create_before_destroy = false
  }

  depends_on = [ mongodbatlas_privatelink_endpoint.privatelink_endpoint_staging ]
}

resource "aws_vpc_endpoint" "vpc_mongodb_prod" {
  vpc_id             = module.vpc.vpc_id
  service_name       = mongodbatlas_privatelink_endpoint.privatelink_endpoint_production.endpoint_service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [module.vpc.default_security_group_id]

  auto_accept         = false
  private_dns_enabled = false

  tags = { Name = "${local.org_short_name}-mongodb-prod" }
  lifecycle {
    create_before_destroy = false
  }

  depends_on = [ mongodbatlas_privatelink_endpoint.privatelink_endpoint_production ]
}