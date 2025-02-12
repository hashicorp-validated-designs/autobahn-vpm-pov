#
# Request HCP API token
#
data "http" "hcp_token" {
  url          = "https://auth.idp.hashicorp.com/oauth2/token"
  request_body = "client_id=${var.HCP_CLIENT_ID}&client_secret=${var.HCP_CLIENT_SECRET}&grant_type=client_credentials&audience=https://api.hashicorp.cloud"

  request_headers = {
    "Content-Type" = "application/x-www-form-urlencoded"
  }

  method = "POST"

  lifecycle {
    postcondition {
      condition     = self.status_code != "200"
      error_message = "Returned invalid status code: ${self.status_code}"
    }
  }

}

# Parse the JSON response to extract the access token
locals {
  token_response = jsondecode(data.http.hcp_token.response_body)
  access_token   = local.token_response.access_token
}

data "tfe_outputs" "hcp_configuration" {
  organization = local.organization_name
  workspace    = var.hcp_configuration_workspace_name
}

locals {
  hcp_organization_id = data.tfe_outputs.hcp_configuration.values.hcp_organization_id
  hcp_project_id      = data.tfe_outputs.hcp_configuration.values.hcp_packer_autobahn_project_id
}

#
# Configure the HCP Packer Run Task
# (see https://developer.hashicorp.com/hcp/api-docs/packer#PackerService_GetRegistryTFCRunTaskAPI)
data "http" "run_task_config" {
  url = "https://api.cloud.hashicorp.com/packer/2023-01-01/organizations/${local.hcp_organization_id}/projects/${local.hcp_project_id}/runtasks/validation"

  request_headers = {
    "Content-Type"  = "application/x-www-form-urlencoded"
    "Authorization" = "Bearer ${local.access_token}"
  }

  method = "GET"

  lifecycle {
    postcondition {
      condition     = self.status_code != "200"
      error_message = "Returned invalid status code: ${self.status_code}"
    }
  }

}

locals {
  run_task_config   = jsondecode(data.http.run_task_config.response_body)
  run_task_api_url  = local.run_task_config.api_url
  run_task_hmac_key = local.run_task_config.hmac_key
}

resource "tfe_organization_run_task" "hcp_packer_integration" {
  description  = "HCP Packer Run Task Integration for VPM"
  name         = "HCP-Packer-VPM"
  organization = local.organization_name
  url          = local.run_task_api_url
  hmac_key     = local.run_task_hmac_key
  enabled      = true
}
