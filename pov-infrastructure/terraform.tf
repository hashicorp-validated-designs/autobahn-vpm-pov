terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.94.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.58.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "hcp" {
  # Configuration options
  project_id = var.hcp_project_id
}

provider "aws" {
  # Configuration options
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy        = "Terraform"
      HCP_TF_Project   = local.project_name_sanitized
      HCP_TF_Workspace = local.workspace_name_sanitized
    }
  }
}

provider "random" {
  # Configuration options
}
