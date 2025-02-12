resource "hcp_packer_bucket" "this" {
  project_id = var.hcp_project_id
  name       = var.bucket_name
}

resource "hcp_packer_channel" "channels" {
  project_id  = var.hcp_project_id
  for_each    = toset(var.channels)
  name        = each.value
  bucket_name = hcp_packer_bucket.this.name
}

# Service Principal IAM binding to maintain Packer images in the bucket
# This service principal is optional
resource "hcp_packer_bucket_iam_binding" "builder" {
  count         = var.builder_service_principal != null ? 1 : 0
  resource_name = hcp_packer_bucket.this.resource_name
  principal_id  = var.builder_service_principal.id
  role          = var.builder_role
}

# Service Principal IAM binding to use Packer images from the bucket
# This service principal is optional
resource "hcp_packer_bucket_iam_binding" "consumer" {
  count         = var.consumer_service_principal != null ? 1 : 0
  resource_name = hcp_packer_bucket.this.resource_name
  principal_id  = var.consumer_service_principal.id
  role          = var.consumer_role
}
