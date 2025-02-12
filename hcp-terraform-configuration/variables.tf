#
# Locals definitions
#
locals {
  organization_name        = split("/", var.TFC_WORKSPACE_SLUG)[0]
  project_name_sanitized   = replace(lower(var.TFC_PROJECT_NAME), " ", "- ")
  workspace_name_sanitized = replace(lower(var.TFC_WORKSPACE_NAME), " ", "-")
}

#
# Variables definitions
# 
variable "TFC_WORKSPACE_SLUG" {
  description = "Workspace slug (sourced from the worker's execution environment variables)"
  type        = string
}

variable "TFC_PROJECT_NAME" {
  description = "Project name (sourced from the worker's execution environent variable)"
  type        = string
}

variable "TFC_WORKSPACE_NAME" {
  description = "Workspace name (sourced from the worker's execution environent variable)"
  type        = string
}

variable "HCP_CLIENT_ID" {
  description = "HCP Client ID (from the environment variable)"
  type        = string
  sensitive   = true
}

variable "HCP_CLIENT_SECRET" {
  description = "HCP Client Secret (from the environment variable)"
  type        = string
  sensitive   = true
}

variable "hcp_configuration_workspace_name" {
  description = "Name of the HCP configuration workspace"
  default     = "hcp-configuration"
  type        = string
}

variable "vpm_pov_deploy_repo_configuration" {
  description = "Configuration for the VPM POV deployment repository"
  type = object({
    vcs_repo_identifier = string
    vcs_repo_branch     = string
    working_directory   = string
  })
}

variable "vpm_pov_project_name" {
  description = "Name of the HCP Terraform project to deploy the VPM PoV infrastructure"
  default     = "vpm-pov"
  type        = string
}

variable "pov_workspace_count" {
  description = "Number of workspace to deploy for the HCP Packer demonstration"
  default     = 10
  type        = number
}

variable "oauth_client_id" {
  description = "The Oauth client ID to use for VCS integration"
  type        = string
}

variable "bucket_name_rhel_base" {
  description = "The bucket name of the RHEL base image"
  type        = string
  default     = "vpm-pov-rhel-cis1-srv"
}

variable "bucket_name_ubuntu_base" {
  description = "The bucket name of the Ubuntu base image"
  type        = string
  default     = "vpm-pov-ubuntu-2204-cis1-srv"
}

variable "bucket_name_ubuntu_nginx" {
  description = "The bucket name of the Ubuntu Nginx image"
  type        = string
  default     = "vpm-pov-ubuntu-2204-cis1-srv-nginx"
}

variable "bucket_name_ubuntu_mysql" {
  description = "The bucket name of the Ubuntu MySQL image"
  type        = string
  default     = "vpm-pov-ubuntu-2204-cis1-srv-nginx"
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string

}

#
# Data sources
#
data "tfe_organization" "this" {
  name = local.organization_name
}

