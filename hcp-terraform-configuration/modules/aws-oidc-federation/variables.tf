variable "hcp_terraform_organization" {
  description = "HCP Terraform organization name"
  type        = string
}

variable "hcp_terraform_project" {
  description = "HCP Terraform project where to configure the OIDC federation"
  type        = string
}

variable "aws_oidc_provider_arn" {
  description = "ARN of the AWS OIDC provider"
  type        = string

}
