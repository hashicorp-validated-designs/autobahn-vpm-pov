#
# Create workspaces to deploy the PoV infrastructure and 
# demonstrate the use of Packer and HCP Packer to patch a
# vulnerability.
#

data "tfe_oauth_client" "client" {
  oauth_client_id = var.oauth_client_id
}

output "tfe_oauth_client_name" {
  value = data.tfe_oauth_client.client.name
}

output "tfe_oauth_client_service_provider" {
  value = data.tfe_oauth_client.client.service_provider_display_name
}

locals {
  padded_suffixes = [
    for i in range(var.pov_workspace_count) :
    format("%02s", i + 1)
  ]
  workspace_names = toset([
    for i in range(var.pov_workspace_count) :
    "pov-workspace-${local.padded_suffixes[i]}"
  ])
}


resource "tfe_workspace" "pov_workspaces" {
  for_each = local.workspace_names
  name     = each.value

  organization = data.tfe_organization.this.name
  project_id   = tfe_project.vpm_pov.id

  working_directory     = var.vpm_pov_deploy_repo_configuration.working_directory
  queue_all_runs        = false
  file_triggers_enabled = true
  trigger_patterns      = ["terraform/**/*"]

  auto_apply          = true
  assessments_enabled = true

  vcs_repo {
    branch         = var.vpm_pov_deploy_repo_configuration.vcs_repo_branch
    identifier     = var.vpm_pov_deploy_repo_configuration.vcs_repo_identifier
    oauth_token_id = data.tfe_oauth_client.client.oauth_token_id
  }

}

resource "tfe_workspace_run_task" "hcp_packer" {
  for_each = local.workspace_names

  workspace_id      = tfe_workspace.pov_workspaces[each.value].id
  task_id           = tfe_organization_run_task.hcp_packer_integration.id
  enforcement_level = "advisory"
  stages            = ["post_plan"]
}
