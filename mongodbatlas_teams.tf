locals {
  environments = ["development", "staging", "production"]
  roles        = ["developer", "tester", "devops"]

  team_defs = {
    for combo in flatten([
      for env in local.environments : [
        for role in local.roles : {
          key  = "${role}-${env}"
          name = lower(join("-", [local.org_short_name, role, env]))
        }
      ]
    ]) : combo.key => combo
  }
}

resource "mongodbatlas_team" "teams" {
  for_each = local.team_defs

  name   = each.value.name
  org_id = local.mongo_org_id

  depends_on = [
        mongodbatlas_project.project_development,
        mongodbatlas_project.project_staging,
        mongodbatlas_project.project_production,
    ]
}
