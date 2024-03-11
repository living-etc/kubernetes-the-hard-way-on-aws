resource "aws_security_group" "instance" {
  name        = "instance"
  description = "Allow traffic to and from instances"
  vpc_id      = aws_vpc.vpc.id
}
