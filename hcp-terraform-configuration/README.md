# HCP Terraform configuration

## Introduction

The code in this directory will configure your HCP Terraform organization with what's needed to run the vulnerability patch management proof of value.

Do not run this step unless you have successfully completed the HCP configuration step (see [instructions](../hcp-configuration/README.md)).

The code in this section will:

1. Create an HCP Terraform project to deploy the VPM PoV infrastructure.
2. Create an AWS OIDC identity provider for HCP Terraform.
3. Create a variable set with the AWS dynamic credentials parameters and apply it to the project.
4. Create a variable set with the HCP Packer bucket information and apply it to the project.
5. Configure a Run Task named `HCP-Packer-VPM` and associate it with the HCP Packer registry created earlier.
6. Create workspaces to deploy the PoV infrastructure under the HCP Terraform project created earlier. Configure the `HCP-Packer-VPM` run task for each of those workspaces (with the run stage set to `Post-Plan`, and the enforcement level set to `Advisory`).
7. Create an `admin` team and a `developer` team, assigning each team the relevant permissions as an example of possible delegation of responsibilities.

## Executing the steps

### Configure AWS access

The creation of the AWS OIDC identity provider for HCP Terraform will require AWS credentials with sufficient permissions.

You must configure the workspace to provide these permissions:

* If the workspace is using the `Remote` execution mode, you may use static credentials (see the tutorial [Create a credentials variable set](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-create-variable-set))
* If the workspace is using `Agent` execution mode, you may use static credentials or use an IAM role (see [Agent authentication](https://developer.hashicorp.com/validated-designs/terraform-operating-guides-scale/selfhosted-agents#agent-authentication)).

### Set workspace variables

If necessary, set the workspace variables to overwrite default values. Inspect the default values in the [Inputs](#inputs) section.

### Apply the configuration

Access the `hcp-terraform-configuration` workspace in the `hcp-configuration` project.

Initiate a Terraform run:

1. Click the **+ New run** button.
2. Validate that the chosen **Run Type** is **Plan and apply (standard)**.
3. Click the **Start** button.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.72.1 |
| <a name="requirement_hcp"></a> [hcp](#requirement\_hcp) | 0.94.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.3 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | 0.57.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.72.1 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.3 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.57.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hcp_terraform_project_aws_oidc_federation"></a> [hcp\_terraform\_project\_aws\_oidc\_federation](#module\_hcp\_terraform\_project\_aws\_oidc\_federation) | ./modules/aws-oidc-federation | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.hcp_terraform](https://registry.terraform.io/providers/hashicorp/aws/5.72.1/docs/resources/iam_openid_connect_provider) | resource |
| [tfe_organization_run_task.hcp_packer_integration](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/organization_run_task) | resource |
| [tfe_project.vpm_pov](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/project) | resource |
| [tfe_project_variable_set.hcp_packer_info](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/project_variable_set) | resource |
| [tfe_project_variable_set.packer_reader_credentials](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/project_variable_set) | resource |
| [tfe_project_variable_set.vpm_pov](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/project_variable_set) | resource |
| [tfe_team.pov_team_admin](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/team) | resource |
| [tfe_team.pov_team_developer](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/team) | resource |
| [tfe_team_project_access.admin](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/team_project_access) | resource |
| [tfe_team_project_access.developer](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/team_project_access) | resource |
| [tfe_variable.hcp_project_id](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable.hcp_terraform_aws_provider_auth](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable.hcp_terraform_role_arn](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable.packer_reader_sp_client_id](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable.packer_reader_sp_client_secret](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable.rhel_base_bucket_name](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable.ubuntu_base_bucket_name](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable.ubuntu_mysql_bucket_name](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable.ubuntu_nginx_bucket_name](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable) | resource |
| [tfe_variable_set.aws_dynamic_credentials](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable_set) | resource |
| [tfe_variable_set.hcp_packer_info](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable_set) | resource |
| [tfe_variable_set.packer_reader_credentials](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/variable_set) | resource |
| [tfe_workspace.pov_workspaces](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/workspace) | resource |
| [tfe_workspace_run_task.hcp_packer](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/resources/workspace_run_task) | resource |
| [http_http.hcp_token](https://registry.terraform.io/providers/hashicorp/http/3.4.3/docs/data-sources/http) | data source |
| [http_http.run_task_config](https://registry.terraform.io/providers/hashicorp/http/3.4.3/docs/data-sources/http) | data source |
| [tfe_oauth_client.client](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/data-sources/oauth_client) | data source |
| [tfe_organization.this](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/data-sources/organization) | data source |
| [tfe_outputs.hcp_configuration](https://registry.terraform.io/providers/hashicorp/tfe/0.57.1/docs/data-sources/outputs) | data source |
| [tls_certificate.provider](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_HCP_CLIENT_ID"></a> [HCP\_CLIENT\_ID](#input\_HCP\_CLIENT\_ID) | HCP Client ID (from the environment variable) | `string` | n/a | yes |
| <a name="input_HCP_CLIENT_SECRET"></a> [HCP\_CLIENT\_SECRET](#input\_HCP\_CLIENT\_SECRET) | HCP Client Secret (from the environment variable) | `string` | n/a | yes |
| <a name="input_TFC_PROJECT_NAME"></a> [TFC\_PROJECT\_NAME](#input\_TFC\_PROJECT\_NAME) | Project name (sourced from the worker's execution environent variable) | `string` | n/a | yes |
| <a name="input_TFC_WORKSPACE_NAME"></a> [TFC\_WORKSPACE\_NAME](#input\_TFC\_WORKSPACE\_NAME) | Workspace name (sourced from the worker's execution environent variable) | `string` | n/a | yes |
| <a name="input_TFC_WORKSPACE_SLUG"></a> [TFC\_WORKSPACE\_SLUG](#input\_TFC\_WORKSPACE\_SLUG) | Workspace slug (sourced from the worker's execution environment variables) | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy the resources | `string` | n/a | yes |
| <a name="input_bucket_name_rhel_base"></a> [bucket\_name\_rhel\_base](#input\_bucket\_name\_rhel\_base) | The bucket name of the RHEL base image | `string` | `"vpm-pov-rhel-cis1-srv"` | no |
| <a name="input_bucket_name_ubuntu_base"></a> [bucket\_name\_ubuntu\_base](#input\_bucket\_name\_ubuntu\_base) | The bucket name of the Ubuntu base image | `string` | `"vpm-pov-ubuntu-2204-cis1-srv"` | no |
| <a name="input_bucket_name_ubuntu_mysql"></a> [bucket\_name\_ubuntu\_mysql](#input\_bucket\_name\_ubuntu\_mysql) | The bucket name of the Ubuntu MySQL image | `string` | `"vpm-pov-ubuntu-2204-cis1-srv-nginx"` | no |
| <a name="input_bucket_name_ubuntu_nginx"></a> [bucket\_name\_ubuntu\_nginx](#input\_bucket\_name\_ubuntu\_nginx) | The bucket name of the Ubuntu Nginx image | `string` | `"vpm-pov-ubuntu-2204-cis1-srv-nginx"` | no |
| <a name="input_hcp_configuration_workspace_name"></a> [hcp\_configuration\_workspace\_name](#input\_hcp\_configuration\_workspace\_name) | Name of the HCP configuration workspace | `string` | `"hcp-configuration"` | no |
| <a name="input_oauth_client_id"></a> [oauth\_client\_id](#input\_oauth\_client\_id) | The Oauth client ID to use for VCS integration | `string` | n/a | yes |
| <a name="input_pov_workspace_count"></a> [pov\_workspace\_count](#input\_pov\_workspace\_count) | Number of workspace to deploy for the HCP Packer demonstration | `number` | `10` | no |
| <a name="input_vpm_pov_deploy_repo_configuration"></a> [vpm\_pov\_deploy\_repo\_configuration](#input\_vpm\_pov\_deploy\_repo\_configuration) | Configuration for the VPM POV deployment repository | <pre>object({<br/>    vcs_repo_identifier = string<br/>    vcs_repo_branch     = string<br/>    working_directory   = string<br/>  })</pre> | n/a | yes |
| <a name="input_vpm_pov_project_name"></a> [vpm\_pov\_project\_name](#input\_vpm\_pov\_project\_name) | Name of the HCP Terraform project to deploy the VPM PoV infrastructure | `string` | `"vpm-pov"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tfe_oauth_client_name"></a> [tfe\_oauth\_client\_name](#output\_tfe\_oauth\_client\_name) | n/a |
| <a name="output_tfe_oauth_client_service_provider"></a> [tfe\_oauth\_client\_service\_provider](#output\_tfe\_oauth\_client\_service\_provider) | n/a |
<!-- END_TF_DOCS -->