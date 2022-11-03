# Create a private Web EC2 Instance
resource "aws_instance" "webhost" {
  count = var.Network["PrivateSubNets"]
  instance_type          = "t2.micro"
  ami                    = var.Image
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_web_traffic_host.id]
  subnet_id              = var.Network["PrivateSubNet_${count.index}"]
  associate_public_ip_address = false

  tags = {
      Name = "${var.Name}-webhost-${count.index}"
  }

  root_block_device {
    volume_size = 8
  }

  depends_on = [
    aws_security_group.sg_web_traffic_host,
    aws_key_pair.key_pair
  ]
}

resource "aws_security_group" "sg_web_traffic_host" {
  name = "${var.Name}-allow-traffic-web-host"
  vpc_id = var.Network.VpcIp

  ingress {
    description = "SG Inbound Web Traffic for EC2 Web Host"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false      
  }
  ingress {
    description = "SG Inbound SSH Traffic from Bastion Host"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = []
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = [aws_security_group.sg_ssh_bastion_host.id]
    self = false      
  }
  ingress {
    description = "SG Inbound ICMP Traffic"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }
  egress {
    description = "SG Inbound ICMP Traffic"
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }

  tags = {
      Name = "${var.Name}-allow-webhost-trafic"
  }
}