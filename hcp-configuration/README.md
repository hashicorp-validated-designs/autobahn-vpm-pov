# HCP configuration

## Introduction

The code in this directory will configure your HCP organization with what's needed to run the vulnerability patch management proof of value.

Do not run this step unless you have successfully completed the bootstraping step (see [instructions](../bootstrap/README.md)).

The code in this section will:

1. Create an HCP project for the Packer VPM PoV.
2. Create a project-level service principal to create and maintain Packer images.
3. Assign to that service principal the `contributor` role.
4. Create a project-level service principal to query the available images in the HCP Packer registry instance.
5. Assign to that service principal the `viewer` role.
6. Create an HCP Packer registry in the HCP project for the Packer VPM POV.
7. Configure the required image buckets and channels.

## Executing the steps

### Set workspace variables

If necessary, set the workspace variables to overwrite default values. Inspect the default values in the [Inputs](#inputs) section.

### Apply the configuration

Access the `hcp-configuration` workspace in the `hcp-configuration` project.

Initiate a Terraform run:

1. Click the **+ New run** button.
2. Validate that the chosen **Run Type** is **Plan and apply (standard)**.
3. Click the **Start** button.

## Important note if you need to destroy the resources in this workspace

If you need to destroy the resources created in this step, we recommend to inventory all the images referenced in this HCP Packer instance and consider de-registering these images as well as deleting the associated snapshots.

Keeping AMIs around does have a cost and if they will not be needed in the future, it is better to properly clean-up the environment.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | 0.94.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcp"></a> [hcp](#provider\_hcp) | 0.94.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcp_packer_bucket.buckets](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/resources/packer_bucket) | resource |
| [hcp_packer_channel.channels](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/resources/packer_channel) | resource |
| [hcp_project.packer_autobahn_project](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/resources/project) | resource |
| [hcp_project_iam_binding.packer_builder](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/resources/project_iam_binding) | resource |
| [hcp_project_iam_binding.packer_reader](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/resources/project_iam_binding) | resource |
| [hcp_service_principal.packer_builder](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/resources/service_principal) | resource |
| [hcp_service_principal.packer_reader](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/resources/service_principal) | resource |
| [hcp_service_principal_key.packer_reader](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/resources/service_principal_key) | resource |
| [terraform_data.hcp_packer_registry](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [hcp_organization.this](https://registry.terraform.io/providers/hashicorp/hcp/0.94.1/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_HCP_CLIENT_ID"></a> [HCP\_CLIENT\_ID](#input\_HCP\_CLIENT\_ID) | n/a | `string` | n/a | yes |
| <a name="input_HCP_CLIENT_SECRET"></a> [HCP\_CLIENT\_SECRET](#input\_HCP\_CLIENT\_SECRET) | n/a | `string` | n/a | yes |
| <a name="input_TFC_WORKSPACE_SLUG"></a> [TFC\_WORKSPACE\_SLUG](#input\_TFC\_WORKSPACE\_SLUG) | Workspace slug (sourced from the worker's execution environment variables) | `string` | n/a | yes |
| <a name="input_bucket_channels"></a> [bucket\_channels](#input\_bucket\_channels) | List of channels an HCP Packer bucket must have | `list(string)` | <pre>[<br/>  "production"<br/>]</pre> | no |
| <a name="input_bucket_names"></a> [bucket\_names](#input\_bucket\_names) | List of bucket names the HCP Packer project must have | `list(string)` | <pre>[<br/>  "rhel-cis1-srv",<br/>  "ubuntu-2204-cis1-srv",<br/>  "ubuntu-2204-cis1-srv-mysql",<br/>  "ubuntu-2204-cis1-srv-nginx"<br/>]</pre> | no |
| <a name="input_hcp_packer_bucket_base_name"></a> [hcp\_packer\_bucket\_base\_name](#input\_hcp\_packer\_bucket\_base\_name) | Base name for the HCP Packer bucket | `string` | `"vpm-pov"` | no |
| <a name="input_packer_builder_vpm_sp_name"></a> [packer\_builder\_vpm\_sp\_name](#input\_packer\_builder\_vpm\_sp\_name) | Name of the HCP service principal (project-level) to maintain Packer images | `string` | `"packer-builder-vpm-sp"` | no |
| <a name="input_packer_reader_vpm_sp_name"></a> [packer\_reader\_vpm\_sp\_name](#input\_packer\_reader\_vpm\_sp\_name) | Name of the HCP service principal (project-level) to use Packer images | `string` | `"packer-reader-vpm-sp"` | no |
| <a name="input_vpm_hcp_project_name"></a> [vpm\_hcp\_project\_name](#input\_vpm\_hcp\_project\_name) | HCP project for the vulnerability patch management proof of value | `string` | `"packer-vpm-project"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hcp_organization_id"></a> [hcp\_organization\_id](#output\_hcp\_organization\_id) | The HCP organization ID |
| <a name="output_hcp_packer_autobahn_project_id"></a> [hcp\_packer\_autobahn\_project\_id](#output\_hcp\_packer\_autobahn\_project\_id) | The resource ID of the Packer Autobahn HCP project |
| <a name="output_packer_reader_sp_client_id"></a> [packer\_reader\_sp\_client\_id](#output\_packer\_reader\_sp\_client\_id) | HCP Packer reader service principal - client ID |
| <a name="output_packer_reader_sp_client_secret"></a> [packer\_reader\_sp\_client\_secret](#output\_packer\_reader\_sp\_client\_secret) | HCP Packer reader service principal - client secret |
<!-- END_TF_DOCS -->