#
# Locals definitions
#
locals {
  organization_name = split("/", var.TFC_WORKSPACE_SLUG)[0]
}

#
# HCP Terraform general configuration
#
variable "hcp_management_project" {
  description = "Name of the HCP Terraform project to hold workspaces used for HCP management"
  type        = string
  default     = "hcp-configuration"
}

#
# Configuration for management workspaces 
#
variable "TFC_WORKSPACE_SLUG" {
  description = "Workspace slug (sourced from the worker's execution environment variables)"
  type        = string
}

variable "hcp_bootstrap_workspace_name" {
  description = "Name of the workspace used to bootstrap HCP management"
  type        = string
  default     = "hcp-bootstrap"
}

variable "hcp_credentials_vs_name" {
  description = "Name of the variable set with the credentials to manage HCP"
  type        = string
  default     = "HCP management credentials"
}

variable "hcp_configuration" {
  description = "Information to configure the HCP configuration workspace"
  type = object({
    workspace_name      = string
    working_directory   = string
    vcs_repo_identifier = string
    vcs_repo_branch     = string
  })
}

variable "hcp_terraform_configuration" {
  description = "Information to configure the HCP Terraform configuration workspace"
  type = object({
    workspace_name      = string
    working_directory   = string
    vcs_repo_identifier = string
    vcs_repo_branch     = string
  })
}

variable "vpm_pov_deploy_repo_identifier" {
  description = "Identifier for the VPM POV deployment repository"
  type        = string
}

#
# GitHub configuration
#
variable "github_oauth_token" {
  description = "Github Personal Access Token with access to the VPM POV repository"
  type        = string
}
