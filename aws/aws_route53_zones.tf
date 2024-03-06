resource "aws_route53_zone" "internal" {
  name = "kthw.internal"

  vpc {
    vpc_id     = aws_vpc.my_vpc.id
    vpc_region = "eu-west-1"
  }
}
