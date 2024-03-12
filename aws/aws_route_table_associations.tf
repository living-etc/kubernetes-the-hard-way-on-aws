resource "aws_route_table_association" "mrta" {
  for_each = aws_subnet.subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.main.id
}
