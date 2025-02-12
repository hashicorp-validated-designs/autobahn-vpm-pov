#
# HCP Packer registry permissions documentation:
# https://developer.hashicorp.com/hcp/docs/packer/reference/permissions
#

# Service Principal to create and maintain Packer images
resource "hcp_service_principal" "packer_builder" {
  name   = var.packer_builder_vpm_sp_name
  parent = hcp_project.packer_autobahn_project.resource_name
}

resource "hcp_project_iam_binding" "packer_builder" {
  project_id   = hcp_project.packer_autobahn_project.resource_id
  principal_id = hcp_service_principal.packer_builder.resource_id
  role         = "roles/contributor"
}

# Service Principal to use Packer images
resource "hcp_service_principal" "packer_reader" {
  name   = var.packer_reader_vpm_sp_name
  parent = hcp_project.packer_autobahn_project.resource_name
}

resource "hcp_project_iam_binding" "packer_reader" {
  project_id   = hcp_project.packer_autobahn_project.resource_id
  principal_id = hcp_service_principal.packer_reader.resource_id
  role         = "roles/viewer"
}

resource "hcp_service_principal_key" "packer_reader" {
  service_principal = hcp_service_principal.packer_reader.resource_name
}
