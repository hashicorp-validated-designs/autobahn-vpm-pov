#
# Create the project for the PoV infrastructure
#
resource "tfe_project" "vpm_pov" {
  organization = local.organization_name
  name         = var.vpm_pov_project_name
  description  = "HCP Terraform project to deploy the VPM PoV infrastructure"
}

#
# Create Dynamic Credentials for the project
#
module "hcp_terraform_project_aws_oidc_federation" {
  source = "./modules/aws-oidc-federation"

  hcp_terraform_organization = tfe_project.vpm_pov.organization
  hcp_terraform_project      = tfe_project.vpm_pov.name
  aws_oidc_provider_arn      = aws_iam_openid_connect_provider.hcp_terraform.arn
}

#
# Variable set for AWS Dynamic Credentials
#
resource "tfe_project_variable_set" "vpm_pov" {
  project_id      = tfe_project.vpm_pov.id
  variable_set_id = tfe_variable_set.aws_dynamic_credentials.id

}

resource "tfe_variable_set" "aws_dynamic_credentials" {
  name         = "aws-dynamic-credentials-for-${tfe_project.vpm_pov.name}"
  description  = "AWS dynamic credentials for the VPM PoV"
  organization = tfe_project.vpm_pov.organization
}

resource "tfe_variable" "hcp_terraform_aws_provider_auth" {
  key             = "TFC_AWS_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.aws_dynamic_credentials.id
}

resource "tfe_variable" "hcp_terraform_role_arn" {
  sensitive       = true
  key             = "TFC_AWS_RUN_ROLE_ARN"
  value           = module.hcp_terraform_project_aws_oidc_federation.iam_role_arn
  category        = "env"
  variable_set_id = tfe_variable_set.aws_dynamic_credentials.id
}

#
# Publish information about HCP Packer buckets
#
resource "tfe_variable_set" "hcp_packer_info" {
  name         = "hcp-packer-info"
  description  = "HCP Packer information for the VPM POV"
  organization = local.organization_name
}

resource "tfe_variable" "rhel_base_bucket_name" {
  key             = "rhel-base-bucket-name"
  value           = var.bucket_name_rhel_base
  category        = "terraform"
  description     = "The bucket name of the RHEL base image"
  variable_set_id = tfe_variable_set.hcp_packer_info.id
}

resource "tfe_variable" "ubuntu_base_bucket_name" {
  key             = "ubuntu-base-bucket-name"
  value           = var.bucket_name_ubuntu_base
  category        = "terraform"
  description     = "The bucket name of the Ubuntu base image"
  variable_set_id = tfe_variable_set.hcp_packer_info.id
}

resource "tfe_variable" "ubuntu_nginx_bucket_name" {
  key             = "ubuntu-nginx-bucket-name"
  value           = var.bucket_name_ubuntu_nginx
  category        = "terraform"
  description     = "The bucket name of the Ubuntu Nginx image"
  variable_set_id = tfe_variable_set.hcp_packer_info.id
}

resource "tfe_variable" "ubuntu_mysql_bucket_name" {
  key             = "ubuntu-mysql-bucket-name"
  value           = var.bucket_name_ubuntu_mysql
  category        = "terraform"
  description     = "The bucket name of the Ubuntu MySQL image"
  variable_set_id = tfe_variable_set.hcp_packer_info.id
}

resource "tfe_variable" "hcp_project_id" {
  key             = "hcp_project_id"
  value           = data.tfe_outputs.hcp_configuration.values.hcp_packer_autobahn_project_id
  category        = "terraform"
  description     = "The HCP project ID for the VPM POV"
  variable_set_id = tfe_variable_set.hcp_packer_info.id
}

resource "tfe_project_variable_set" "hcp_packer_info" {
  project_id      = tfe_project.vpm_pov.id
  variable_set_id = tfe_variable_set.hcp_packer_info.id
}

#
# Publish information about HCP Packer credential reader
#
resource "tfe_variable_set" "packer_reader_credentials" {
  description  = "HCP Packer reader credentials"
  name         = "hcp-packer-reader-credentials"
  priority     = true
  organization = local.organization_name
}

resource "tfe_variable" "packer_reader_sp_client_id" {
  description     = "HCP Packer reader service principal - client ID"
  key             = "HCP_CLIENT_ID"
  value           = data.tfe_outputs.hcp_configuration.values.packer_reader_sp_client_id
  sensitive       = true
  category        = "env"
  variable_set_id = tfe_variable_set.packer_reader_credentials.id
}

resource "tfe_variable" "packer_reader_sp_client_secret" {
  description     = "HCP Packer reader service principal - client secret"
  key             = "HCP_CLIENT_SECRET"
  value           = data.tfe_outputs.hcp_configuration.values.packer_reader_sp_client_secret
  sensitive       = true
  category        = "env"
  variable_set_id = tfe_variable_set.packer_reader_credentials.id
}

resource "tfe_project_variable_set" "packer_reader_credentials" {
  project_id      = tfe_project.vpm_pov.id
  variable_set_id = tfe_variable_set.packer_reader_credentials.id
}
