terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.60.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "domain_name" {
  default = "test-groenbek.com"
}

variable "website_docker_image_tag" {
  default = "latest"
}

variable "server_docker_image_tag" {
  default = "latest"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "groenbek-vpc"
  }
}

resource "aws_subnet" "public" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-central-1a"

  tags = {
    Name = "public-subnet"
  }

  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-central-1b"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}


resource "aws_ecr_repository" "main" {
  name                 = "groenbek"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repo_id" {
  value = aws_ecr_repository.main.registry_id
}
resource "aws_ecs_cluster" "main" {
  name = "groenbek"
}

resource "aws_security_group" "ecs" {
  name_prefix = "groenbek-ecs"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "main" {
  name            = "groenbek-website"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    subnets         = [aws_subnet.public.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "groenbek-website"
    container_port   = 3000
  }
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "groenbek-ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}



resource "aws_launch_template" "ecs" {
  name_prefix   = "groenbek-ecs"
  image_id      = data.aws_ssm_parameter.ecs_ami_id.value
  instance_type = "t2.micro"
  depends_on    = [aws_ecs_service.main]
  user_data = base64encode(<<-EOF
  #!/bin/bash
  echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
  echo ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true >> /etc/ecs/ecs.config
EOF
  )

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance_profile.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  name_prefix      = "groenbek-ecs"
  desired_capacity = 1
  min_size         = 1
  max_size         = 1

  vpc_zone_identifier = [
    aws_subnet.public.id,
    aws_subnet.private.id,
  ]

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs_instance_role.name
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/groenbek-website"
}

resource "aws_ecs_task_definition" "main" {
  family             = "groenbek"
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions = jsonencode([
    {
      "name" : "groenbek-website",
      "image" : "${aws_ecr_repository.main.repository_url}:${var.website_docker_image_tag}",
      "memoryReservation" : 512,
      "portMappings" : [
        {
          "containerPort" : 3000,
          "hostPort" : 3000,
          "protocol" : "tcp"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.ecs_logs.name}",
          "awslogs-region" : "eu-central-1",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
  tags = {
    Name = "groenbek-website-task-definition"
  }
  network_mode = "awsvpc"
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "groenbek-ecs-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecrPullPolicy" {
  name = "ecrPullPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "taskExecutionPolicy" {
  name = "taskExecutionPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_ecr" {
  policy_arn = aws_iam_policy.ecrPullPolicy.arn
  role       = aws_iam_role.ecsTaskExecutionRole.name
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_task_execution" {
  policy_arn = aws_iam_policy.taskExecutionPolicy.arn
  role       = aws_iam_role.ecsTaskExecutionRole.name
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "groenbek-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "groenbek-igw-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_lb" "main" {
  name = "groenbek"
  subnets = [
    aws_subnet.public.id,
    aws_subnet.private.id,
  ]
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

  tags = {
    Name = "groenbek-lb"
  }
}

resource "aws_lb_target_group" "main" {
  name        = "groenbek"
  port        = 3000
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  depends_on = [
    aws_lb.main,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lb" {
  name_prefix = "groenbek-lb"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.main.arn
    type             = "forward"
  }
}
