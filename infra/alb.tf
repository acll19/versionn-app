resource "aws_lb" "versionn-app-alb" {
  name               = "versionn-app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
      aws_subnet.versionn-app-subnet-public.id,
      aws_subnet.versionn-app-subnet-b.id
  ]
}

resource "aws_lb_target_group" "version-app-target-group" {
  name        = "${var.app_prefix}-lb-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.versionn-app-vpc.id
  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/version"
    timeout             = 5
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
  port              = "${var.container_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.version-app-target-group.arn}"
    type             = "forward"
  }
}