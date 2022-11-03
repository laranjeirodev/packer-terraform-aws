output "Private_Instances_IP_addresses" {
  value = aws_instance.webhost.*.private_ip
}

output "Bastion_Host_IP_address" {
  value = aws_instance.bastion.public_ip
}

output "Load_balancer_HTTP_DNS" {
  value = aws_lb.alb_webhosts.dns_name
}

output "SSH_key_Content" {
  value = tls_private_key.key.private_key_pem
}

output "Usernames" {
  value = "ec2-user"
}

output "ec2_public_dns" {
  value = aws_instance.bastion.public_dns
}

output "ec2_public_ip" {
  value = aws_eip.eip.public_ip
}