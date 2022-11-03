resource "aws_eip" "eip_nat_gw" {

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
      Name = "${var.Name}-eip-natgateway"
  }    
}
