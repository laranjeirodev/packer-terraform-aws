variable "aws_region" {
    type = string
}

locals {
    user_data = jsondecode(file("../packer/packer-manifest.json"))
}

output "golden_image_ami" {
  value = split(":", local.user_data.builds[0].artifact_id)[1]

}

output "manifest" {
  value = local.user_data
}

