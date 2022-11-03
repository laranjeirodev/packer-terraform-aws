variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "ami_name" {
  type    = string
  default = "packer-amazon2-aws-{{timestamp}}"
}

source "amazon-ebs" "linux" {
  ami_name      = var.ami_name
  instance_type = "t2.micro"
  region        = var.region
  tags = {
    "Created-by" = "Packer"
  }

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
      architecture        = "x86_64"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.linux"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo \"<h1>Hello World at ${formatdate("YYYY-MM-DD", timestamp())}</h1>\" | sudo tee /var/www/html/index.html"
    ]
  }

  post-processor "manifest" {
    output     = "packer-manifest.json"
    strip_path = true
  }
}
