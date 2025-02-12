variable "hcp_project_id" {
  description = "Id of the HCP project to create the Packer bucket"
  type        = string
}

variable "bucket_name" {
  description = "Name of the HCP Packer bucket"
  type        = string
}

variable "builder_service_principal" {
  description = "Id of the HCP service principal to maintain Packer image version in the bucket"
  type = object({
    id = string
  })
  nullable = true
  default  = null
}

variable "builder_role" {
  description = "Role of the HCP service principal to maintain Packer image version in the bucket"
  type        = string
  default     = "roles/contributor"
}

variable "consumer_service_principal" {
  description = "Id of the HCP service principal to use Packer image version from the bucket"
  type = object({
    id = string
  })
  nullable = true
  default  = null
}

variable "consumer_role" {
  description = "Role of the HCP service principal to use Packer image version from the bucket"
  type        = string
  default     = "roles/viewer"
}

variable "channels" {
  description = "List of channels the HCP Packer bucket must have"
  type        = list(string)
  default     = ["production"]
}
