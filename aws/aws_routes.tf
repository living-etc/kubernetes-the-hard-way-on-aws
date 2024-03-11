resource "aws_route" "internet" {
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "worker_routes" {
  for_each               = aws_instance.workers
  route_table_id         = aws_route_table.main.id
  destination_cidr_block = local.workers[each.value.tags["Name"]].pod_cidr
  network_interface_id   = each.value.primary_network_interface_id
}
