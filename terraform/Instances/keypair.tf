resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.Name}-ssh-instance-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "pem_file" {
  filename = pathexpand("./${var.Name}-ssh-instance-key.pem")
  file_permission = "600"
  directory_permission = "700"
  sensitive_content = tls_private_key.key.private_key_pem
}