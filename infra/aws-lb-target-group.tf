resource "aws_lb_target_group" "version-app-target-group" {
  name        = "${var.app_prefix}-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.versionn-app-vpc.id
  target_type = "ip"
  depends_on = [aws_lb.versionn-app-alb]
}