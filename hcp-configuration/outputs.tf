output "hcp_organization_id" {
  value       = data.hcp_organization.this.resource_id
  description = "The HCP organization ID"
  sensitive   = false
}

output "hcp_packer_autobahn_project_id" {
  value       = hcp_project.packer_autobahn_project.resource_id
  description = "The resource ID of the Packer Autobahn HCP project"
  sensitive   = false
}

output "packer_reader_sp_client_id" {
  description = "HCP Packer reader service principal - client ID"
  value       = hcp_service_principal_key.packer_reader.client_id
  sensitive   = true
}

output "packer_reader_sp_client_secret" {
  description = "HCP Packer reader service principal - client secret"
  value       = hcp_service_principal_key.packer_reader.client_secret
  sensitive   = true
}
