resource "aws_vpc" "vcp_galp" {
    cidr_block = var.Network_CIDR
    tags = {
        Name = "${var.Name}-Vpc"
    }
}
