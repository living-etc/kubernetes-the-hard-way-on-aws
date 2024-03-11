resource "aws_lb_listener" "port_6443" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.controllers_target_group.arn
  }
}
