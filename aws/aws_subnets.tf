resource "aws_subnet" "my_subnets" {
  for_each          = local.subnets
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.name
}
