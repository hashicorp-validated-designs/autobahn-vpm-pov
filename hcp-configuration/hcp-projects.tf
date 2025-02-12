data "hcp_organization" "this" {

}

#
# HCP configuration for the Packer Autobahn POV
#
resource "hcp_project" "packer_autobahn_project" {
  name        = var.vpm_hcp_project_name
  description = "HCP project for the Packer VPM POV"
}
