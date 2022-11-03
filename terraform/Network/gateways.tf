resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vcp_galp.id

  tags = {
      Name = "${var.Name}-InternetGateway-public-subnets"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_nat_gw.id
  subnet_id = aws_subnet.private_subnet.0.id

  tags = {
      Name = "${var.Name}-Natgateway-private-subnets"
  }    
}