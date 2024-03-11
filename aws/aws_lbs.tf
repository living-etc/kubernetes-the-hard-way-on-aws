resource "aws_lb" "alb" {
  name                       = "controllers"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = values(aws_subnet.subnets).*.id
  enable_deletion_protection = false
}
