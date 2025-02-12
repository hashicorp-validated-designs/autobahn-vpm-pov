resource "tfe_team" "pov_team_admin" {
  name         = "pov-team-admin"
  organization = local.organization_name
}

resource "tfe_team" "pov_team_developer" {
  name         = "pov-team-developer"
  organization = local.organization_name
}

resource "tfe_team_project_access" "admin" {
  access     = "admin"
  team_id    = tfe_team.pov_team_admin.id
  project_id = tfe_project.vpm_pov.id
}

resource "tfe_team_project_access" "developer" {
  access     = "custom"
  team_id    = tfe_team.pov_team_developer.id
  project_id = tfe_project.vpm_pov.id

  project_access {
    settings = "read"
    teams    = "none"
  }

  workspace_access {
    runs           = "apply"
    sentinel_mocks = "none"
    state_versions = "read-outputs"
    variables      = "read"
    create         = false
    locking        = false
    delete         = false
    move           = false
    run_tasks      = false
  }

}

