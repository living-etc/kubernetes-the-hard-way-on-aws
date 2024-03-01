resource "aws_subnet" "my_subnets" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}
