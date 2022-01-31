resource "aws_security_group" "versionn-app-alb-security-group" {
  name        = "${var.app_prefix}-security-group"
  vpc_id      = "${aws_vpc.versionn-app-vpc.id}"

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "versionn-app-alb" {
  name               = "versionn-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.versionn-app-alb-security-group.id}"]
  subnets            = [
      aws_subnet.versionn-app-subnet-public.id,
      aws_subnet.versionn-app-subnet-b.id
  ]
}

resource "aws_lb_target_group" "version-app-target-group" {
  name_prefix = "vn-app"
  port        = var.load_balancer_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.versionn-app-vpc.id
  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/version"
    timeout             = 25
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = 200
  }

  depends_on = [aws_lb.versionn-app-alb]
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "version-app-listener_http" {
  load_balancer_arn = "${aws_lb.versionn-app-alb.arn}"
  port              = "${var.load_balancer_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.version-app-target-group.arn}"
    type             = "forward"
  }
}