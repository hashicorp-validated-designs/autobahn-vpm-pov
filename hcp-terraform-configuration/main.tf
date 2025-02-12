#
# Create AWS OIDC provider configuration
# (setting up trust relationship between AWS and HCP Terraform)
# 


locals {
  hcp_terraform_url = "https://app.terraform.io"
}

data "tls_certificate" "provider" {
  url = local.hcp_terraform_url
}

resource "aws_iam_openid_connect_provider" "hcp_terraform" {
  url = local.hcp_terraform_url

  client_id_list = [
    "aws.workload.identity", # Default audience in HCP Terraform for AWS.
  ]

  thumbprint_list = [
    data.tls_certificate.provider.certificates[0].sha1_fingerprint,
  ]
}

