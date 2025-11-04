# Network Containers
resource "mongodbatlas_network_container" "network_container_development" {
  project_id       = mongodbatlas_project.project_development.id
  atlas_cidr_block = "192.168.248.0/21"
  provider_name    = "AWS"
  region_name      = "AP_SOUTH_1"

  depends_on = [mongodbatlas_project.project_development]
}

resource "mongodbatlas_network_container" "network_container_staging" {
  project_id       = mongodbatlas_project.project_staging.id
  atlas_cidr_block = "192.168.248.0/21"
  provider_name    = "AWS"
  region_name      = "AP_SOUTH_1"

  depends_on = [mongodbatlas_project.project_staging]
}

resource "mongodbatlas_network_container" "network_container_production" {
  project_id       = mongodbatlas_project.project_production.id
  atlas_cidr_block = "192.168.248.0/21"

  provider_name = "AWS"
  region_name   = "AP_SOUTH_1"

  depends_on = [mongodbatlas_project.project_production]
}

resource "mongodbatlas_privatelink_endpoint" "privatelink_endpoint_development" {
  project_id    = mongodbatlas_project.project_development.id
  provider_name = local.provider_name
  region        = local.region

  timeouts {
    create = "60m"
    delete = "60m"
  }

  depends_on = [mongodbatlas_project.project_development]
}

resource "mongodbatlas_privatelink_endpoint" "privatelink_endpoint_staging" {
  project_id    = mongodbatlas_project.project_staging.id
  provider_name = local.provider_name
  region        = local.region

  timeouts {
    create = "60m"
    delete = "60m"
  }

  depends_on = [mongodbatlas_project.project_staging]
}

resource "mongodbatlas_privatelink_endpoint" "privatelink_endpoint_production" {
  project_id    = mongodbatlas_project.project_production.id
  provider_name = local.provider_name
  region        = local.region

  timeouts {
    create = "60m"
    delete = "60m"
  }

  depends_on = [mongodbatlas_project.project_production]
}