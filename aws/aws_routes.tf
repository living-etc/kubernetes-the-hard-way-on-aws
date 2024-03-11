resource "aws_route" "internet" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route" "worker_routes" {
  for_each               = { for i, w in local.workers : i => w }
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = each.value.pod_cidr
  network_interface_id   = aws_instance.workers[each.key].primary_network_interface_id
}
