resource "aws_subnet" "public_subnet" {
  count = floor(var.N_Subnets / 2)
  vpc_id     = aws_vpc.vcp_galp.id
  cidr_block = cidrsubnet(var.Network_CIDR, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
      Name = "${var.Name}-PublicSubNet-${count.index}"
  }
}