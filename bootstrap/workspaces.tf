resource "tfe_oauth_client" "github" {
  name             = "vpm-pov-github-client"
  organization     = local.organization_name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_oauth_token
  service_provider = "github"
}

resource "tfe_workspace" "hcp_configuration" {
  name         = var.hcp_configuration.workspace_name
  description  = "Workspace to configure the HCP organization"
  organization = local.organization_name
  project_id   = tfe_project.hcp_configuration.id

  working_directory = var.hcp_configuration.working_directory
  queue_all_runs    = false

  file_triggers_enabled = true
  trigger_patterns      = ["${var.hcp_configuration.working_directory}/**/*"]

  remote_state_consumer_ids = [tfe_workspace.hcp_terraform_configuration.id]

  vcs_repo {
    identifier     = var.hcp_configuration.vcs_repo_identifier
    branch         = var.hcp_configuration.vcs_repo_branch
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_workspace" "hcp_terraform_configuration" {
  name         = var.hcp_terraform_configuration.workspace_name
  description  = "Workspace to configure the HCP Terraform organization"
  organization = local.organization_name
  project_id   = tfe_project.hcp_configuration.id

  working_directory = var.hcp_terraform_configuration.working_directory
  queue_all_runs    = false

  file_triggers_enabled = true
  trigger_patterns      = ["${var.hcp_terraform_configuration.working_directory}/**/*"]

  vcs_repo {
    identifier     = var.hcp_terraform_configuration.vcs_repo_identifier
    branch         = var.hcp_terraform_configuration.vcs_repo_branch
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_variable" "hcp_configuration_workspace_name" {
  description  = "HCP Configuration workspace name"
  key          = "hcp_configuration_workspace_name"
  value        = tfe_workspace.hcp_configuration.name
  category     = "terraform"
  workspace_id = tfe_workspace.hcp_terraform_configuration.id
}

resource "tfe_variable" "tfe_oauth_client_id" {
  description  = "The Oauth client ID to use for VCS integration"
  key          = "oauth_client_id"
  value        = tfe_oauth_client.github.id
  category     = "terraform"
  workspace_id = tfe_workspace.hcp_terraform_configuration.id
}

resource "tfe_variable" "vpm_pov_deploy_repo_configuration" {
  description = "VPM POV deployment repository configuration"
  key         = "vpm_pov_deploy_repo_configuration"
  value = jsonencode({
    vcs_repo_identifier = var.vpm_pov_deploy_repo_identifier
    vcs_repo_branch     = "main"
    working_directory   = "pov-infrastructure"
  })
  category     = "terraform"
  hcl          = true
  workspace_id = tfe_workspace.hcp_terraform_configuration.id
}
