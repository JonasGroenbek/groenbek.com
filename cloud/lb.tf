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

resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
