resource "aws_vpc" "my_vpc" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
}
