resource "aws_lb_target_group" "controllers_target_group" {
  name     = "controllers-target-group"
  port     = 6443
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/healthz"
    port                = 80
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
