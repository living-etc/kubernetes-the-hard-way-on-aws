resource "aws_route_table_association" "my_route_table_association" {
  count          = length(aws_subnet.my_subnets.*.id)
  subnet_id      = aws_subnet.my_subnets[count.index].id
  route_table_id = aws_route_table.main.id
}
