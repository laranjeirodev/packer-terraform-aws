module "goldenImageModule" {
  source = "./Golden_Image"
  aws_region = var.aws_region
}

module "networkmodule" {
    source = "./network"
    Network_CIDR = var.Network_CIDR
    N_Subnets = var.N_Subnets
    Name = var.Name

    depends_on = [
      module.goldenImageModule
    ]
}

module "instancemodule" {
    source = "./instances"
    Network = module.networkmodule.Network
    Image = module.goldenImageModule.golden_image_ami
    Name = var.Name

    depends_on = [
      module.networkmodule
    ]
}