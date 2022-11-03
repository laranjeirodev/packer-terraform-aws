data "aws_subnet_ids" "public-subnet-ids" {
  vpc_id = var.Network.VpcIp

  filter {
    name   = "map-public-ip-on-launch"
    values = [true]
  }
}

resource "aws_lb_target_group" "target_group_webhosts" {
  name = "${var.Name}-tg-webhosts"
  port = 80
  protocol = "HTTP"
  vpc_id = var.Network.VpcIp
  health_check {
    enabled = true
    healthy_threshold = 3
    interval = 10
    matcher = 200
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.Name}-tg-webhosts"
  }
}

resource "aws_lb_target_group_attachment" "attach-webhosts" {
  count = var.Network["PrivateSubNets"]
  target_group_arn = aws_lb_target_group.target_group_webhosts.arn
  target_id = "${element(aws_instance.webhost.*.id, count.index)}"             
  port = 80
}

resource "aws_security_group" "sg_alb_webhost" {
  name = "${var.Name}-allow-http-webhost"
  vpc_id = var.Network.VpcIp

  ingress {
    description = "SG Inbound HTTP Traffic"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }

  egress {
    description = "SG Outbound All Traffic"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
  }
  egress {
    description = "SG Outbound All Traffic"
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
      Name = "${var.Name}-allow-http-webhost"
  }
}

resource "aws_lb" "alb_webhosts" {
  name = "${var.Name}-alb-webhosts"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.sg_alb_webhost.id ]
  subnets = data.aws_subnet_ids.public-subnet-ids.ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.Name}-alb-webhosts"
  }

  depends_on = [
    aws_instance.webhost,
    aws_lb_target_group.target_group_webhosts
  ]
}

resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_lb.alb_webhosts.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group_webhosts.arn
  }
}
