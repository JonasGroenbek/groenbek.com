resource "aws_ecs_cluster" "main" {
  name = "groenbek"
}

resource "aws_ecs_task_definition" "main" {
  family             = "groenbek"
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = jsonencode([
    {
      name  = "groenbek-website"
      image = "${aws_ecr_repository.main.repository_url}:${var.website_docker_image_tag}"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "http"
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
  name            = "groenbek-website"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    subnets         = [aws_subnet.private.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "groenbek-website"
    container_port   = 3000
  }
}

resource "aws_security_group" "ecs" {
  name_prefix = "groenbek-ecs"
  vpc_id      = aws_vpc.main.id
}
