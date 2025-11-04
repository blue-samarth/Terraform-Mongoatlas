resource "random_string" "mongodbatlas_database_username_development" {
  length  = 16
  special = false
}

resource "random_string" "mongodbatlas_database_username_staging" {
  length  = 16
  special = false
}

resource "random_string" "mongodbatlas_database_username_production" {
  length  = 16
  special = false
}

resource "random_string" "mongodbatlas_database_password_development" {
  length  = 32
  special = true
}

resource "random_string" "mongodbatlas_database_password_staging" {
  length  = 32
  special = true
}

resource "random_string" "mongodbatlas_database_password_production" {
  length  = 32
  special = true
}

resource "mongodbatlas_database_user" "database_user_development" {
  project_id         = mongodbatlas_project.project_development.id
  username           = random_string.mongodbatlas_database_username_development.result
  password           = random_string.mongodbatlas_database_password_development.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "%s"
    value = "%s"
  }

  scopes {
    name = mongodbatlas_advanced_cluster.advanced_cluster_development.name
    type = "CLUSTER"
  }

  depends_on = [ mongodbatlas_advanced_cluster.advanced_cluster_development ]
}

resource "mongodbatlas_database_user" "database_user_staging" {
  project_id         = mongodbatlas_project.project_staging.id
  username           = random_string.mongodbatlas_database_username_staging.result
  password           = random_string.mongodbatlas_database_password_staging.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "%s"
    value = "%s"
  }

  scopes {
    name = mongodbatlas_advanced_cluster.advanced_cluster_staging.name
    type = "CLUSTER"
  }

    depends_on = [ mongodbatlas_advanced_cluster.advanced_cluster_staging ]
}

resource "mongodbatlas_database_user" "database_user_production" {
  project_id         = mongodbatlas_project.project_production.id
  username           = random_string.mongodbatlas_database_username_production.result
  password           = random_string.mongodbatlas_database_password_production.result
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "%s"
    value = "%s"
  }

  scopes {
    name = mongodbatlas_advanced_cluster.advanced_cluster_production.name
    type = "CLUSTER"
  }

    depends_on = [ mongodbatlas_advanced_cluster.advanced_cluster_production ]
}