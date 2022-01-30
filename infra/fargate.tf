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
    execution_role_arn       = aws_iam_role.versionn-app-role.arn
    container_definitions    =  <<DEFINITION
    [
        {
            "name": "${var.app_prefix}-app",
            "image": "${var.app_image_name}",
            "cpu": ${var.app_cpu_limit},
            "memory": ${var.app_memory_limit},
            "essential": true,
            "portMappings": [{
                "containerPort": ${var.container_port},
                "hostPort": ${var.container_port}
            }],
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "${aws_cloudwatch_log_group.versionn-app-task-log-group.name}",
                    "awslogs-region": "${var.region}",
                    "awslogs-stream-prefix": "ecs"
                } 
            }
        }
    ]
    DEFINITION
}

resource "aws_ecs_service" "versionn-app-service" {
  name            = "${var.app_prefix}-service"
  cluster         = aws_ecs_cluster.versionn-app-ecs-cluster.id
  task_definition = aws_ecs_task_definition.versionn-app-task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.version-app-target-group.arn
    container_name   = "${var.app_prefix}-app"
    container_port   = var.container_port
  }

  network_configuration {
      assign_public_ip = true
      subnets = [
          aws_subnet.versionn-app-subnet-public.id, 
          aws_subnet.versionn-app-subnet-b.id
      ]
  }
}