resource "terraform_data" "hcp_packer_registry" {

  triggers_replace = [hcp_project.packer_autobahn_project.resource_id]

  input = {
    org_id     = data.hcp_organization.this.resource_id
    project_id = hcp_project.packer_autobahn_project.resource_id
  }

  provisioner "local-exec" {

    command = "${path.module}/scripts/create-registry.sh"

    environment = {
      HCP_ORGANIZATION_ID = self.input.org_id
      HCP_PROJECT_ID      = self.input.project_id
    }

  }

  provisioner "local-exec" {

    when    = destroy
    command = "${path.module}/scripts/delete-registry.sh"

    environment = {
      HCP_ORGANIZATION_ID = self.input.org_id
      HCP_PROJECT_ID      = self.input.project_id
    }

  }

}

locals {
  bucket_names = toset([for name in var.bucket_names : "${var.hcp_packer_bucket_base_name}-${name}"])
  # Build a map of channel+bucket that must exist
  bucket_name_channel = { for pair in setproduct(var.bucket_channels, local.bucket_names) : "${pair[0]}.${pair[1]}" => {
    channel_name = pair[0]
    bucket_name  = pair[1]
    }
  }
}

# module "packer_bucket" {
#   source = "./modules/packer_bucket"

#   for_each                   = toset(var.bucket_names)
#   bucket_name                = "${var.hcp_packer_bucket_base_name}-${each.value}"
#   hcp_project_id             = hcp_project.packer_autobahn_project.resource_id
#   builder_service_principal  = { id = hcp_service_principal.packer_builder.resource_id }
#   consumer_service_principal = { id = hcp_service_principal.packer_reader.resource_id }
#   channels                   = var.bucket_channels
#   depends_on                 = [terraform_data.hcp_packer_registry]
# }

resource "hcp_packer_bucket" "buckets" {
  project_id = hcp_project.packer_autobahn_project.resource_id
  for_each   = local.bucket_names
  name       = each.value
  depends_on = [terraform_data.hcp_packer_registry]
}

resource "hcp_packer_channel" "channels" {
  project_id  = hcp_project.packer_autobahn_project.resource_id
  for_each    = local.bucket_name_channel
  name        = each.value.channel_name
  bucket_name = hcp_packer_bucket.buckets[each.value.bucket_name].name
}
