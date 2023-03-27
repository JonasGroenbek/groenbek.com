resource "aws_ecs_cluster" "main" {
  name = "groenbek-ecs-cluster"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "main" {
  family             = "groenbek-ecs-task-definition"
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name  = "groenbek-ecs-task-definition"
      image = "${aws_ecr_repository.main.repository_url}:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
}


resource "aws_ecs_service" "main" {
  name            = "groenbek-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.private.*.id[0]]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "groenbek"
    container_port   = 3000
  }
}

resource "aws_security_group" "ecs" {
  name_prefix = "groenbek-ecs"
  vpc_id      = aws_vpc.main.id
}
