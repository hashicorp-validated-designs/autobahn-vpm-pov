#
# Locals definitions
#
locals {
  organization_name = split("/", var.TFC_WORKSPACE_SLUG)[0]
}

#
# Variables definitions
#

variable "TFC_WORKSPACE_SLUG" {
  description = "Workspace slug (sourced from the worker's execution environment variables)"
  type        = string
}

variable "vpm_hcp_project_name" {
  description = "HCP project for the vulnerability patch management proof of value"
  default     = "packer-vpm-project"
}

variable "packer_builder_vpm_sp_name" {
  description = "Name of the HCP service principal (project-level) to maintain Packer images"
  default     = "packer-builder-vpm-sp"
}

variable "packer_reader_vpm_sp_name" {
  description = "Name of the HCP service principal (project-level) to use Packer images"
  default     = "packer-reader-vpm-sp"
}

variable "HCP_CLIENT_ID" {
  type = string
}

variable "HCP_CLIENT_SECRET" {
  type      = string
  sensitive = true
}

variable "hcp_packer_bucket_base_name" {
  description = "Base name for the HCP Packer bucket"
  type        = string
  default     = "vpm-pov"

}

variable "bucket_names" {
  description = "List of bucket names the HCP Packer project must have"
  type        = list(string)
  default     = ["rhel-cis1-srv", "ubuntu-2204-cis1-srv", "ubuntu-2204-cis1-srv-mysql", "ubuntu-2204-cis1-srv-nginx"]
}

variable "bucket_channels" {
  description = "List of channels an HCP Packer bucket must have"
  type        = list(string)
  default     = ["production"]
}
