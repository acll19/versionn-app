resource "aws_lb" "versionn-app-alb" {
  name               = "versionn-app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
      aws_subnet.versionn-app-subnet-a.id,
      aws_subnet.versionn-app-subnet-b.id
  ]
}