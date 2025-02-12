# AWS OIDC Federation module

This module will create an IAM Role and make the ARN for the role available as an output.

The role will be assigned the following example permissions:

* `AmazonEC2FullAccess` (operations on EC2)
* `AmazonS3FullAccess` (operations on S3)

## Requirements

In the root module, you must include the `aws` provider in the `terraform` > `required_providers` section, as well as include a `provider` block. For example:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "aws" {
  # Configuration options
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.vpm_pov_provisioner_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.pov_ec2_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.pov_s3_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy.pov_ec2_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.pov_s3_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.pov_oidc_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_oidc_provider_arn"></a> [aws\_oidc\_provider\_arn](#input\_aws\_oidc\_provider\_arn) | ARN of the AWS OIDC provider | `string` | n/a | yes |
| <a name="input_hcp_terraform_organization"></a> [hcp\_terraform\_organization](#input\_hcp\_terraform\_organization) | HCP Terraform organization name | `string` | n/a | yes |
| <a name="input_hcp_terraform_project"></a> [hcp\_terraform\_project](#input\_hcp\_terraform\_project) | HCP Terraform project where to configure the OIDC federation | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of the IAM role to be assumed by the HCP Terraform organization |
<!-- END_TF_DOCS -->