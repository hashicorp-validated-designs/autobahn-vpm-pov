# Bootstraping the environment

## Introduction

The code in this directory will bootstrap your HCP and HCP Terraform environment, to be used in the vulnerability patch management proof of value.

The prerequisites are documented in the main [README](../README.md) file.

The code in this section will:

1. Create a project in HCP Terraform to manage the workspaces used to configure HCP and HCP Terraform.
2. Apply the variable set with the HCP management credentials to the project.
3. Create a workspace to manage the HCP configuration, and link it to the appropriate `git` repository.
4. Create a workspace to manage the HCP Terraform configuration, and link it to the appropriate `git` repository.

The instructions in this document assume that you are using GitHub as your VCS and CI/CD platform. However the integration is relatively simple and adapting it to another solution should be easy achieve.

## Executing the step

The instructions in this section assume that the default values for the variables fit your situation. If that is not the case, you should provide alternate values by defining additional workspace variables.

Take the time to review the [Inputs](#inputs) section below to determine if you need to change any of the default values.

### GitHub Oauth Token

You will need a GitHub Oauth token with the permissions to access the VPM POV repositories.

Follow you organization's practices to generate the token and have it handy before starting this step.

### HCP Terraform

* Login to HCP Terraform and perform the following steps.

* Create a new workspace in the **Default Project**.

* When prompted, select **VCS-Driven Workflow**.

* Select your GitHub VCS provider.

* Choose the repository where you imported this setup configuration.

* Set the **Workspace Name** to `hcp-bootstrap`.

* Set the **Terraform Working Directory** to `bootstrap`.

* Click the **Create** button.

* When prompted, set the following variables:

| Variable Name                    | Value                                                                                                                                                                                                                                                  | Marked Sensitive? | Category    | HCL? |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------- | ----------- | ---- |
| `github_oauth_token`             | The Oauth token                                                                                                                                                                                                                                        | Yes               | `terraform` | No   |
| `hcp_configuration`              | <pre>{<br/>&nbsp;&nbsp;workspace_name = "hcp-configuration"<br/>&nbsp;&nbsp;vcs_repo_branch = "main"<br/>&nbsp;&nbsp;working_directory = "hcp-configuration"<br/>&nbsp;&nbsp;vcs_repo_identifier = "owner/repository"<br/>}</pre>                      | No                | `terraform` | Yes  |
| `hcp_terraform_configuration`    | <pre>{<br/>&nbsp;&nbsp;workspace_name = "hcp-terraform-configuration"<br/>&nbsp;&nbsp;vcs_repo_branch = "main"<br/>&nbsp;&nbsp;working_directory = "hcp-terraform-configuration"<br/>&nbsp;&nbsp;vcs_repo_identifier =  "owner/repository"<br/>}</pre> | No                | `terraform` | Yes  |
| `vpm_pov_deploy_repo_identifier` | (set it to the git repository identifier for this repo, following the format `owner/repository`)                                                                                                                                                                                                 | No                | `terraform`   | No   |

* Update the **HCP management credentials** variable set to apply it to this new workspace.

* Trigger a Terraform run.

<details>

<summary>HCP Terraform complains about my configurationm, what should I do?</summary>

If you copied-and-pasted the variable values from the table above, and the Terraform run failed with the following error message, don't worry: `Expected a newline or comma to mark the beginning of the next attribute.`

The copy-and-paste operation did not include the newlines. You have two options:

1. Add the newlines to separate each attribute value (`shift-ENTER` should do the trick), or
2. Separate each attribute value definition with a `,`.

Once this is done, re-submit the Terraform run and it should work.

</details>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | 0.56.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.56.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_oauth_client.github](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/resources/oauth_client) | resource |
| [tfe_project.hcp_configuration](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/resources/project) | resource |
| [tfe_project_variable_set.hcp_credentials](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/resources/project_variable_set) | resource |
| [tfe_variable.hcp_configuration_workspace_name](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/resources/variable) | resource |
| [tfe_variable.tfe_oauth_client_id](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/resources/variable) | resource |
| [tfe_variable.vpm_pov_deploy_repo_configuration](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/resources/variable) | resource |
| [tfe_workspace.hcp_configuration](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/resources/workspace) | resource |
| [tfe_workspace.hcp_terraform_configuration](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/resources/workspace) | resource |
| [tfe_variable_set.hcp_credentials](https://registry.terraform.io/providers/hashicorp/tfe/0.56.0/docs/data-sources/variable_set) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_TFC_WORKSPACE_SLUG"></a> [TFC\_WORKSPACE\_SLUG](#input\_TFC\_WORKSPACE\_SLUG) | Workspace slug (sourced from the worker's execution environment variables) | `string` | n/a | yes |
| <a name="input_github_oauth_token"></a> [github\_oauth\_token](#input\_github\_oauth\_token) | Github Personal Access Token with access to the VPM POV repository | `string` | n/a | yes |
| <a name="input_hcp_bootstrap_workspace_name"></a> [hcp\_bootstrap\_workspace\_name](#input\_hcp\_bootstrap\_workspace\_name) | Name of the workspace used to bootstrap HCP management | `string` | `"hcp-bootstrap"` | no |
| <a name="input_hcp_configuration"></a> [hcp\_configuration](#input\_hcp\_configuration) | Information to configure the HCP configuration workspace | <pre>object({<br>    workspace_name      = string<br>    working_directory   = string<br>    vcs_repo_identifier = string<br>    vcs_repo_branch     = string<br>  })</pre> | n/a | yes |
| <a name="input_hcp_credentials_vs_name"></a> [hcp\_credentials\_vs\_name](#input\_hcp\_credentials\_vs\_name) | Name of the variable set with the credentials to manage HCP | `string` | `"HCP management credentials"` | no |
| <a name="input_hcp_management_project"></a> [hcp\_management\_project](#input\_hcp\_management\_project) | Name of the HCP Terraform project to hold workspaces used for HCP management | `string` | `"hcp-configuration"` | no |
| <a name="input_hcp_terraform_configuration"></a> [hcp\_terraform\_configuration](#input\_hcp\_terraform\_configuration) | Information to configure the HCP Terraform configuration workspace | <pre>object({<br>    workspace_name      = string<br>    working_directory   = string<br>    vcs_repo_identifier = string<br>    vcs_repo_branch     = string<br>  })</pre> | n/a | yes |
| <a name="input_vpm_pov_deploy_repo_identifier"></a> [vpm\_pov\_deploy\_repo\_identifier](#input\_vpm\_pov\_deploy\_repo\_identifier) | Identifier for the VPM POV deployment repository | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->