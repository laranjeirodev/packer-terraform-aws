provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.Tags
  }
}

output "Private_instances_IP_addresses" {
  value = module.instancemodule.Private_Instances_IP_addresses
}

output "Bastion_Host_IP" {
  value = module.instancemodule.ec2_public_ip
}

output "SSH_key_content" {
  value     = module.instancemodule.SSH_key_Content
  sensitive = true
}

output "Load_blanacer_HTTP_Content" {
  value = module.instancemodule.Load_balancer_HTTP_DNS
}

output "Usernames" {
  value = module.instancemodule.Usernames
}

output "Golden_Image_ami" {
  value = module.goldenImageModule.golden_image_ami
}
