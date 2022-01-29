resource "aws_ecs_service" "versionn-app-service" {
  name            = "${var.app_prefix}-service"
  cluster         = aws_ecs_cluster.versionn-app-ecs-cluster.id
  task_definition = aws_ecs_task_definition.versionn-app-task.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.version-app-target-group.arn
    container_name   = "${var.app_prefix}-app"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_target_group.version-app-target-group]
}