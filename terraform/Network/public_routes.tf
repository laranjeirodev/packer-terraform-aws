resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vcp_galp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
      Name = "${var.Name}-public-rt"
  }  
}

resource "aws_route_table_association" "public_rt_association" {
  count = floor(var.N_Subnets / 2)

  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.public_rt.id
}
