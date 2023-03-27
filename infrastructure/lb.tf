resource "aws_lb" "main" {
  name               = "groenbek-lb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_target_group" "main" {
  name     = "groenbek-lb-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_security_group" "lb" {
  name_prefix = "groenbek-lb"
  vpc_id      = aws_vpc.main.id
}
