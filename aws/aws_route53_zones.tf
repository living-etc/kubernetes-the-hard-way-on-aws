resource "aws_route53_zone" "internal" {
  name = "kthw.internal"

  vpc {
    vpc_id     = aws_vpc.vpc.id
    vpc_region = local.aws_region
  }
}
