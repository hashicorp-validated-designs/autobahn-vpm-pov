
resource "random_id" "name_suffix" {
  byte_length = 4
}

data "hcp_packer_artifact" "ubuntu" {
  bucket_name  = var.ubuntu-base-bucket-name
  channel_name = var.channel_name
  platform     = "aws"
  region       = var.aws_region
}

resource "aws_instance" "ubuntu" {
  ami           = data.hcp_packer_artifact.ubuntu.external_identifier
  instance_type = var.instance_type

  tags = {
    Name = "vpm-pov-virtual-machine-${random_id.name_suffix.hex}"
  }
}
