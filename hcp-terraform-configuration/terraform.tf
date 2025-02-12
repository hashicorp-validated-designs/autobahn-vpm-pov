terraform {

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.94.1"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "0.57.1"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.3"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "hcp" {
  # Configuration options

  # TODO: Create a Sentinel policy to block an apply when HCP credentials are
  # set using the `client_id` and the `client_secret` attributes

}

provider "tfe" {

}

provider "http" {
  # Configuration options
}

provider "aws" {
  # Configuration options
  region = var.aws_region
}
