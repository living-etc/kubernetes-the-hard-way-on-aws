resource "aws_subnet" "my_subnets" {
  for_each = { for i, az in data.aws_availability_zones.available.names : i => az }

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, each.key)
  availability_zone = each.value
}
