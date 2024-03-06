resource "aws_lb" "my_alb" {
  name                       = "controllers"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = [for subnet in aws_subnet.my_subnets : subnet.id]
  enable_deletion_protection = false
}
