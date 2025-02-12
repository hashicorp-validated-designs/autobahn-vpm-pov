# Deploy PoV infrastructure

This repository contains the Terraform configuration in support of the Autobahn VPM POV. The configuration expects that the infrastructure will be deployed using HCP Terraform.

It will deploy a single Ubuntu EC2 instance and tag it with the HCP Terraform project and workspace that's managing it.

Once linked to a workspace, before trying to execute a Terraform Apply operation, you must verify that the workspace has the required configuration to use (or get) the credentials necessary to configure infrastructure in the cloud. This should have been set up by a variable set applied at the project level, configuring the necessary environment variables for the workspace to use AWS dynamic provider credentials.

The workspace takes a number of input values (see the [Inputs](#inputs) section below) which will have been set up for you if you've used the bootstraping code from this repository (see [README](../README.md) and [README](../documentation/README.md)).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.58.0 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | 0.94.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.58.0 |
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.94.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/resources/instance) | resource |
| [random_id.name_suffix](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/id) | resource |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/5.58.0/docs/data-sources/vpc) | data source |
| [hcp_packer_artifact.ubuntu](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/data-sources/packer_artifact) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_TFC_PROJECT_NAME"></a> [TFC\_PROJECT\_NAME](#input\_TFC\_PROJECT\_NAME) | TFC Project Name (sourced from the TFC execution environment variables) | `string` | n/a | yes |
| <a name="input_TFC_WORKSPACE_NAME"></a> [TFC\_WORKSPACE\_NAME](#input\_TFC\_WORKSPACE\_NAME) | TFC Workspace Name (sourced from the TFC execution environment variables) | `string` | n/a | yes |
| <a name="input_TFC_WORKSPACE_SLUG"></a> [TFC\_WORKSPACE\_SLUG](#input\_TFC\_WORKSPACE\_SLUG) | TFC Workspace slug (sourced from the TFC execution environment variables) | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region where to deploy the infrastructure | `string` | `"us-east-2"` | no |
| <a name="input_channel_name"></a> [channel\_name](#input\_channel\_name) | HCP Packer channel to use | `string` | `"production"` | no |
| <a name="input_hcp_project_id"></a> [hcp\_project\_id](#input\_hcp\_project\_id) | The HCP project ID for the VPM POV | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type of deploy | `string` | `"t2.micro"` | no |
| <a name="input_rhel-base-bucket-name"></a> [rhel-base-bucket-name](#input\_rhel-base-bucket-name) | The bucket name of the RHEL base image | `string` | n/a | yes |
| <a name="input_ubuntu-base-bucket-name"></a> [ubuntu-base-bucket-name](#input\_ubuntu-base-bucket-name) | The bucket name of the Ubuntu base image | `string` | n/a | yes |
| <a name="input_ubuntu-mysql-bucket-name"></a> [ubuntu-mysql-bucket-name](#input\_ubuntu-mysql-bucket-name) | The bucket name of the Ubuntu MySQL image | `string` | n/a | yes |
| <a name="input_ubuntu-nginx-bucket-name"></a> [ubuntu-nginx-bucket-name](#input\_ubuntu-nginx-bucket-name) | The bucket name of the Ubuntu Nginx image | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
