resource "aws_lb" "versionn-app-alb" {
  name               = "versionn-app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
      aws_subnet.versionn-app-subnet-public.id,
      aws_subnet.versionn-app-subnet-b.id
  ]
}