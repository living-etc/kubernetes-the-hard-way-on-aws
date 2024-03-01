resource "aws_route" "internet" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route" "worker_routes" {
  count                  = 3
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "10.200.${count.index + 1}.0/24"
  network_interface_id   = aws_instance.workers[count.index].primary_network_interface_id
}
