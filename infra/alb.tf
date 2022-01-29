resource "aws_lb" "versionn-app-alb" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.versionn-app-subnet.id]
}