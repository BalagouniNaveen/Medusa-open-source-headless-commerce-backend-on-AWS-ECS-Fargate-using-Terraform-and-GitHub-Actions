resource "aws_lb" "medusa_alb" {
  name               = "medusa-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "medusa_tg" {
  name     = "medusa-tg"
  port     = 9000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}
