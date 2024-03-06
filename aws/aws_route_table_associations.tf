resource "aws_route_table_association" "my_route_table_association" {
  for_each       = aws_subnet.my_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main.id
}
