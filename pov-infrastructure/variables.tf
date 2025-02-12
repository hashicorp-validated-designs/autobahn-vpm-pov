variable "aws_region" {
  description = "The AWS region where to deploy the infrastructure"
  type        = string
  default     = "us-east-2"
}

variable "hcp_project_id" {
  description = "The HCP project ID for the VPM POV"
  type        = string
}

variable "channel_name" {
  description = "HCP Packer channel to use"
  type        = string
  default     = "production"
}

variable "rhel-base-bucket-name" {
  description = "The bucket name of the RHEL base image"
  type        = string
}

variable "ubuntu-base-bucket-name" {
  description = "The bucket name of the Ubuntu base image"
  type        = string
}

variable "ubuntu-mysql-bucket-name" {
  description = "The bucket name of the Ubuntu MySQL image"
  type        = string
}

variable "ubuntu-nginx-bucket-name" {
  description = "The bucket name of the Ubuntu Nginx image"
  type        = string
}

variable "instance_type" {
  description = "The instance type of deploy"
  type        = string
  default     = "t2.micro"
}

locals {
  tfc_organization_name    = split("/", var.TFC_WORKSPACE_SLUG)[0]
  project_name_sanitized   = replace(lower(var.TFC_PROJECT_NAME), " ", "-")
  workspace_name_sanitized = replace(lower(var.TFC_WORKSPACE_NAME), " ", "-")
}

variable "TFC_PROJECT_NAME" {
  type        = string
  description = "TFC Project Name (sourced from the TFC execution environment variables)"
}

variable "TFC_WORKSPACE_NAME" {
  type        = string
  description = "TFC Workspace Name (sourced from the TFC execution environment variables)"
}

variable "TFC_WORKSPACE_SLUG" {
  type        = string
  description = "TFC Workspace slug (sourced from the TFC execution environment variables)"
}
