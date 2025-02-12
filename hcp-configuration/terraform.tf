terraform {

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.94.1"
    }
  }
}

provider "hcp" {
  # Configuration options

  # TODO: Create a Sentinel policy to block an apply when HCP credentials are
  # set using the `client_id` and the `client_secret` attributes

}
