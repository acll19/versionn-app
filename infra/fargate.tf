resource "aws_ecs_cluster" "versionn-app-ecs-cluster" {
  name = "${var.app_prefix}-ECSCluster"

  tags = {
    Name = "${var.app_prefix}-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "versionn-app-task" {
    family                   = "${var.app_prefix}-ECSTaskDefinition"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu                      = "${var.app_cpu_limit}"
    memory                   = "${var.app_memory_limit}"
    container_definitions    = jsonencode([
        {
            name         = "${var.app_prefix}-app"
            image        = "${var.app_image_name}"
            cpu          = var.app_cpu_limit
            memory       = var.app_memory_limit
            essential    = true
            portMappings = [{
                containerPort = var.container_port
                hostPort     = var.container_port
            }]
        }
    ])
}

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

  network_configuration {
      subnets: [aws_subnet.versionn-app-subnet-public, aws_subnet.versionn-app-subnet-b]
  }
}