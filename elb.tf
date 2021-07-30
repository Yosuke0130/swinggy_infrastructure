# ------------------------
# ALB
# ------------------------
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-api-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.alb_sg.id
  ]
  subnets = [
    aws_subnet.private_subnet_api.id,
    #未作成
    aws_subnet.private_subnet_api_2.id
  ]
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

# ------------------------
# Target Group
# ------------------------
resource "aws_lb_target_group" "alb_target_group" {
  name     = "${var.project}-${var.environment}-api-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-api-tg"
    project = var.project
    Env     = var.environment
  }
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  #未作成
  target_id = aws_instance.api_server.id
}