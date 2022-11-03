resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vcp_galp.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
      Name = "${var.Name}-private-rt"
  }    
}

resource "aws_route_table_association" "private_rt_association" {
  count = ceil(var.N_Subnets / 2)

  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.private_rt.id
}