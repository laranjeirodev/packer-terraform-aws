resource "aws_subnet" "private_subnet" {
  count = ceil(var.N_Subnets / 2)
  vpc_id     = aws_vpc.vcp_galp.id
  cidr_block = cidrsubnet(var.Network_CIDR, 8, count.index+floor(var.N_Subnets / 2))
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
      Name = "${var.Name}-PrivateSubNet-${count.index}"
  }
}