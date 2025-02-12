# Vulnerability Patch Management Proof of Value

## Overview

This repository contains the code to bootstrap and configure the HCP and HCP Terraform
environment to run the vulnerability patch management (VPM) proof of value (PoV).

The code is broken down into four sections:

| Directory                     | Purpose                                                               | Documentation                                     |
| ----------------------------- | --------------------------------------------------------------------- | ------------------------------------------------- |
| `bootstrap`                   | Code to bootstrap the HCP and HCP Terraform environment               | [README](./bootstrap/README.md)                   |
| `hcp-configuration`           | Code to maintain the configuration of your HCP organization           | [README](./hcp-configuration/README.md)           |
| `hcp-terraform-configuration` | Code to maintain the configuration of your HCP Terraform organization | [README](./hcp-terraform-configuration/README.md) |
| `pov-infrastructure`          | Code to deploy the example PoV infrastructure                         | [README](./pov-infrastructure/README.md)          |

When deploying the environment for the VPM PoV initially, you must execute the code in the following order:

1. Code in the `bootstrap` directory.
2. Code in the `hcp-configuration` directory.
3. Code in the `hcp-terraform-configuration` directory.

While the bootstraping code is intended to be used only once, the code in the other two sections can be the base of a long-lived HCP and HCP Terraform configuration.

The `pov-infrastructure` code depends on a separate repository ([hashicorp/autobahn-vpm-gha-packer](https://github.com/hashicorp/autobahn-vpm-gha-packer)) defining the Packer templates and example GHA workflows to automate the creation of the Packer images. Additional details about the required step sequence is documented here: [README](documentation/README.md).

## Prerequisites

There are a number of prerequisites before you can start using the code in this repository. This section will list those prerequisites.

### Version control

You must have imported the git repositories provided by the HashiCorp team in your GitHub installation (this repository, and the Packer templates repository).

### HCP organization

You must have created an HCP organization, and created a service principal (named for example `hcp-admin-sp`) with
the following role and scope:

| Role        | Scope              |
| ----------- | ------------------ |
| Contributor | Organization-level |

You should also have generated keys for the service principal (the client ID and client secret) which will be used later in the process.

Link to documentation:

* [What is HCP?](https://developer.hashicorp.com/hcp/docs/hcp)
* [Create an HCP Account](https://developer.hashicorp.com/hcp/docs/hcp/create-account)
* [Create an organization](https://developer.hashicorp.com/hcp/docs/hcp/admin/orgs#create-an-organization)
* [Service Principals](https://developer.hashicorp.com/hcp/docs/hcp/iam/service-principal)

### HCP Terraform organization

You must have created an HCP Terraform organization and completed the configuration tasks explained below.

First, you need to generate a Team API token for the `Owners` team.

Second, you will create a variable set for HCP management credentials and activate the option `Prioritize the variable values in this variable set`.

Define the following variables in this variable set:

| Key                      | Value                                                      | Category | Sensitive flag |
| ------------------------ | ---------------------------------------------------------- | -------- | -------------- |
| HCP_CLIENT_ID            | The client ID for the `hcp-admin-sp` service principal     | env      | Yes            |
| HCP_CLIENT_SECRET        | The client secret for the `hcp-admin-sp` service principal | env      | Yes            |
| TF_VAR_HCP_CLIENT_ID     | The client ID for the `hcp-admin-sp` service principal     | env      | Yes            |
| TF_VAR_HCP_CLIENT_SECRET | The client secret for the `hcp-admin-sp` service principal | env      | Yes            |
| TFE_TOKEN                | The `Owners` Team API token                                | env      | Yes            |

The bootstraping code expects this variable set to be named `HCP management credentials`. If you decide to use another name,
simply provide the alternate name as a parameter value (for the variable named `hcp_credentials_vs_name`).

Then, you need to have configured a VCS provider to provide your HCP Terraform organization access to the GitHub repositories you imported earlier (see the **Version control** section).

Link to documentation:

* [What is HCP Terraform?](https://developer.hashicorp.com/terraform/cloud-docs)
* [Get Started - HCP Terraform](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)
* [API Tokens](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens)
* [The Owners Team](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/teams#the-owners-team)
* [Variables](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables)
* [Create a credentials variable set](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-create-variable-set)
* [Connecting VCS Providers to HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs/vcs)
