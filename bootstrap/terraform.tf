terraform {

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.56.0"
    }
  }

  cloud {
    organization = "emrousselle-tfcb-sandbox"

    workspaces {
      name = "hcp-bootstrap"
    }
  }
}

provider "tfe" {
  # Configuration options
}
