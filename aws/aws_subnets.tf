resource "aws_subnet" "subnets" {
  for_each          = local.subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.name
}
