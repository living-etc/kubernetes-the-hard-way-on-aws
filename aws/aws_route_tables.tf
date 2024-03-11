resource "aws_route_table" "main" {
  vpc_id = aws_vpc.vpc.id
}
