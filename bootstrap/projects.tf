#
# Create the project to manage the HCP and HCP Terraform configuration
#
resource "tfe_project" "hcp_configuration" {
  organization = local.organization_name
  name         = var.hcp_management_project
  description  = "Project to manage the HCP and HCP Terraform configuration"
}

#
# Link the variable set with the HCP credentials to the project
#
data "tfe_variable_set" "hcp_credentials" {
  name         = var.hcp_credentials_vs_name
  organization = local.organization_name
}

resource "tfe_project_variable_set" "hcp_credentials" {
  project_id      = tfe_project.hcp_configuration.id
  variable_set_id = data.tfe_variable_set.hcp_credentials.id
}
