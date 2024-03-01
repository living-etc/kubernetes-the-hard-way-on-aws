resource "aws_lb_target_group_attachment" "controllers_attachment" {
  count            = length(aws_instance.controllers.*.id)
  target_group_arn = aws_lb_target_group.controllers_target_group.arn
  target_id        = aws_instance.controllers[count.index].id
  port             = 6443
}
