output "Network" {
    value = merge(tomap({
          "VpcIp" = aws_vpc.vcp_galp.id,
          "PrivateSubNets" = length(aws_subnet.private_subnet)
          "PublicSubNet" = aws_subnet.public_subnet.0.id
        }),
      {for index, psbn in aws_subnet.private_subnet : "PrivateSubNet_${index}" => psbn.id})
}