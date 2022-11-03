data "aws_ami" "linux" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"] 
  }
  filter {
    name = "root-device-type"
    values = ["ebs"] 
  }  
}

# Create a EC2 Instance Bastion Host
resource "aws_instance" "bastion" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.linux.id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_ssh_bastion_host.id]
  subnet_id              = var.Network["PublicSubNet"]

  tags = {
      Name = "${var.Name}-bastion-host"
  }

  root_block_device {
    volume_size = 8
  }

  depends_on = [
    aws_security_group.sg_ssh_bastion_host,
    aws_key_pair.key_pair
  ]
}

# Create and assosiate an Elastic IP for Bastion Host
resource "aws_eip" "eip" {
  instance = aws_instance.bastion.id

  tags = {
      Name = "${var.Name}-eip-bastion-host"
  }
}

variable "ingress_sg_bastion" {
  type = list(number)
  default = [22]
}

variable "egress_sg_bastion" {
  type = list(number)
  default = [22, 80]
}

resource "aws_security_group" "sg_ssh_bastion_host" {
  name = "${var.Name}-allow-ssh-bastion-host"
  vpc_id = var.Network.VpcIp

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_sg_bastion
    content {
      description = "SG Inbound SSH for EC2 Bastion Host"
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false      
    }
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

  dynamic "egress" {
    iterator = port
    for_each = var.egress_sg_bastion
    content {
      description = "SG Outbound from EC2 Bastion Host to private EC2 Instance (SSH, HTTP)"
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false      
    }
  }
  egress {
    description = "SG Outbound ICMP Traffic"
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
      Name = "${var.Name}-allow-ssh-bastion-host"
  }
}