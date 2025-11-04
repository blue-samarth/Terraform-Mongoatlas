resource "mongodbatlas_privatelink_endpoint_service" "private_endpoint_service_development" {
  project_id          = mongodbatlas_project.project_development.id
  provider_name       = local.provider_name
  endpoint_service_id = aws_vpc_endpoint.vpc_mongodb_dev.id
  private_link_id     = mongodbatlas_private_endpoint.privatelink_endpoint_development.id

  depends_on = [
    mongodbatlas_private_endpoint.privatelink_endpoint_development,
    aws_vpc_endpoint.vpc_mongodb_dev
  ]
}

resource "mongodbatlas_privatelink_endpoint_service" "private_endpoint_service_staging" {
  project_id          = mongodbatlas_project.project_staging.id
  provider_name       = local.provider_name
  endpoint_service_id = aws_vpc_endpoint.vpc_mongodb_staging.id
  private_link_id     = mongodbatlas_private_endpoint.privatelink_endpoint_staging.id

  depends_on = [
    mongodbatlas_private_endpoint.privatelink_endpoint_staging,
    aws_vpc_endpoint.vpc_mongodb_staging
  ]
}

resource "mongodbatlas_privatelink_endpoint_service" "private_endpoint_service_production" {
  project_id          = mongodbatlas_project.project_production.id
  provider_name       = local.provider_name
  endpoint_service_id = aws_vpc_endpoint.vpc_mongodb_prod.id
  private_link_id     = mongodbatlas_private_endpoint.privatelink_endpoint_production.id

  depends_on = [
    mongodbatlas_private_endpoint.privatelink_endpoint_production,
    aws_vpc_endpoint.vpc_mongodb_prod
  ]
}
