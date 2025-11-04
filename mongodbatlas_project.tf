resource "mongodbatlas_project" "project_development" {
  name   = lower(join("-", [local.org_short_name, "project", "development"]))
  org_id = local.org_id

  with_default_alerts_settings                     = true
  is_collect_database_specifics_statistics_enabled = false
  is_data_explorer_enabled                         = true
  is_extended_storage_sizes_enabled                = false
  is_performance_advisor_enabled                   = true
  is_realtime_performance_panel_enabled            = true
  is_schema_advisor_enabled                        = true

  tags = {
    Owner       = "Terraform"
    environment = "development"
    team        = "devops"
  }
}

resource "mongodbatlas_project" "project_staging" {
  name   = lower(join("-", [local.org_short_name, "project", "staging"]))
  org_id = local.org_id

  with_default_alerts_settings                     = true
  is_collect_database_specifics_statistics_enabled = false
  is_data_explorer_enabled                         = true
  is_extended_storage_sizes_enabled                = false
  is_performance_advisor_enabled                   = true
  is_realtime_performance_panel_enabled            = true
  is_schema_advisor_enabled                        = true

  tags = {
    Owner       = "Terraform"
    environment = "staging"
    team        = "devops"
  }

}

resource "mongodbatlas_project" "project_production" {
  name   = lower(join("-", [local.org_short_name, "project", "production"]))
  org_id = local.org_id

  with_default_alerts_settings                     = true
  is_collect_database_specifics_statistics_enabled = true
  is_data_explorer_enabled                         = false
  is_extended_storage_sizes_enabled                = true
  is_performance_advisor_enabled                   = true
  is_realtime_performance_panel_enabled            = true
  is_schema_advisor_enabled                        = true

  tags = {
    Owner       = "Terraform"
    environment = "production"
    team        = "devops"
  }
}