resource "mongodbatlas_advanced_cluster" "advanced_cluster_development" {
  project_id     = mongodbatlas_project.project_development.id
  name           = lower(join("-", [local.org_short_name, "advanced", "cluster", "development"]))
  cluster_type   = "REPLICASET"
  backup_enabled = false

  encryption_at_rest_provider = "NONE"
  mongo_db_major_version      = "8.0"
  bi_connector_config         = { enabled = false }

  replication_specs = [{
    region_configs = [{
      analytics_specs = {
        instance_size = "M10"
        node_count    = 0
      }

      electable_specs = {
        instance_size = "M10"
        node_count    = 3
      }

      read_only_specs = {
        instance_size = "M10"
        node_count    = 0
      }

      auto_scaling = {
        compute_enabled            = false
        disk_gb_enabled            = false
        compute_scale_down_enabled = false
      }

      analytics_auto_scaling = {
        compute_enabled            = false
        disk_gb_enabled            = false
        compute_scale_down_enabled = false
      }

      region_name   = "US_EAST_1"
      priority      = 7
      provider_name = "AWS"
    }]
  }]

  termination_protection_enabled       = false
  version_release_system               = "LTS"
  replica_set_scaling_strategy         = "SEQUENTIAL"
  delete_on_create_timeout             = true
  global_cluster_self_managed_sharding = false
  paused                               = false
  redact_client_log_data               = false

  tags = {
    Owner       = "Terraform"
    environment = "development"
    team        = "devops"
    Project     = lower(join("-", [local.org_short_name, "project", "development"]))
  }
}

resource "mongodbatlas_advanced_cluster" "advanced_cluster_staging" {
  project_id     = mongodbatlas_project.project_staging.id
  name           = lower(join("-", [local.org_short_name, "advanced", "cluster", "staging"]))
  cluster_type   = "REPLICASET"
  backup_enabled = false

  encryption_at_rest_provider = "NONE"
  mongo_db_major_version      = "8.0"
  bi_connector_config         = { enabled = false }

  replication_specs = [{
    region_configs = [{
      analytics_specs = {
        instance_size = "M10"
        node_count    = 0
      }

      electable_specs = {
        instance_size = "M10"
        node_count    = 3
      }

      read_only_specs = {
        instance_size = "M10"
        node_count    = 0
      }

      auto_scaling = {
        compute_enabled            = false
        disk_gb_enabled            = false
        compute_scale_down_enabled = false
      }

      analytics_auto_scaling = {
        compute_enabled            = false
        disk_gb_enabled            = false
        compute_scale_down_enabled = false
      }

      region_name   = "US_EAST_1"
      priority      = 7
      provider_name = "AWS"
    }]
  }]

  termination_protection_enabled       = false
  version_release_system               = "LTS"
  replica_set_scaling_strategy         = "SEQUENTIAL"
  delete_on_create_timeout             = true
  global_cluster_self_managed_sharding = false
  paused                               = false
  redact_client_log_data               = false

  tags = {
    Owner       = "Terraform"
    environment = "staging"
    team        = "devops"
    Project     = lower(join("-", [local.org_short_name, "project", "staging"]))
  }
}

resource "mongodbatlas_advanced_cluster" "advanced_cluster_production" {
  project_id     = mongodbatlas_project.project_production.id
  name           = lower(join("-", [local.org_short_name, "advanced", "cluster", "production"]))
  cluster_type   = "REPLICASET"
  backup_enabled = true

  encryption_at_rest_provider = "NONE"
  mongo_db_major_version      = "8.0"
  bi_connector_config         = { enabled = false }

  replication_specs = [{
    region_configs = [{
      analytics_specs = {
        instance_size = "M20"
        node_count    = 0
      }

      electable_specs = {
        instance_size = "M20"
        node_count    = 3
      }

      read_only_specs = {
        instance_size = "M10"
        node_count    = 0
      }

      auto_scaling = {
        compute_enabled            = true
        disk_gb_enabled            = true
        compute_scale_down_enabled = true
      }

      analytics_auto_scaling = {
        compute_enabled            = false
        disk_gb_enabled            = false
        compute_scale_down_enabled = false
      }

      region_name   = "US_EAST_1"
      priority      = 7
      provider_name = "AWS"
    }]
  }]

  termination_protection_enabled       = false
  version_release_system               = "LTS"
  replica_set_scaling_strategy         = "SEQUENTIAL"
  delete_on_create_timeout             = true
  global_cluster_self_managed_sharding = false
  paused                               = false
  redact_client_log_data               = false

  tags = {
    Owner       = "Terraform"
    environment = "production"
    team        = "devops"
    Project     = lower(join("-", [local.org_short_name, "project", "production"]))
  }
}