resource "aws_lb_target_group_attachment" "controllers_attachment" {
  for_each = aws_instance.controllers

  target_group_arn = aws_lb_target_group.controllers_target_group.arn
  target_id        = each.value.id
  port             = 6443
}
