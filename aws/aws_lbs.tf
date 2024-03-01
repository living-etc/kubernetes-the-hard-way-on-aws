resource "aws_lb" "my_alb" {
  name                       = "controllers"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = aws_subnet.my_subnets[*].id
  enable_deletion_protection = false
}
