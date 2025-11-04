locals {
  users = {
    developer = [
      "dev2@testing.com",
      "dev1@testing.com"
    ]
    tester = [
      "tester1@testing.com",
      "tester2@testing.com"
    ]
    devops = [
      "samarth@testing.com",
      "sharma@testing.com"
    ]
  }

  role_permissions = {
    developer = ["GROUP_DATA_ACCESS_ADMIN"]
    tester    = ["GROUP_DATA_ACCESS_READ_WRITE"]
    devops    = ["GROUP_OWNER"]
    readonly  = ["GROUP_DATA_ACCESS_READ_ONLY"]
  }

  # Flatten environment + role + user combinations
  user_assignments_individual = merge([
    for env in ["development", "staging", "production"] : merge([
      for role, user_emails in local.users : {
        for idx, user_email in user_emails :
        "${env}-${role}-${idx}" => {
          environment = env
          role        = role
          user_email  = user_email

          permissions = (
            env == "development" && role == "developer" ? ["GROUP_OWNER"] :
            env == "staging" && role == "tester" ? ["GROUP_DATA_ACCESS_ADMIN"] :
            env == "production" ? ["GROUP_DATA_ACCESS_READ_ONLY"] :
            local.role_permissions[role]
          )
          team = "mongoatlas_team_${role}_${env}"
        }
      }
    ]...)
  ]...)
}

resource "mongodbatlas_cloud_user_project_assignment" "user_project_assignments" {
  for_each = local.user_assignments_individual

  project_id = {
    development = mongodbatlas_project.project_development.id
    staging     = mongodbatlas_project.project_staging.id
    production  = mongodbatlas_project.project_production.id
  }[each.value.environment]
  username = each.value.user_email
  roles    = each.value.permissions

    depends_on = [ mongodbatlas_team.teams ]
}

resource "mongodbatlas_cloud_user_team_assignment" "user_team_assignments" {
  for_each = local.user_assignments_individual

  org_id  = local.mongo_org_id
  team_id = mongodbatlas_team.teams["${each.value.role}-${each.value.environment}"].id
  user_id = mongodbatlas_cloud_user_project_assignment.user_project_assignments[each.key].id

    depends_on = [ mongodbatlas_cloud_user_project_assignment.user_project_assignments ]
}