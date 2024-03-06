resource "aws_route53_record" "workers_internal" {
  for_each = aws_instance.workers

  zone_id = aws_route53_zone.internal.zone_id
  name    = each.value.tags["Name"]
  type    = "A"
  ttl     = "30"
  records = [each.value.private_ip]
}

resource "aws_route53_record" "controllers_internal" {
  for_each = aws_instance.controllers

  zone_id = aws_route53_zone.internal.zone_id
  name    = each.value.tags["Name"]
  type    = "A"
  ttl     = "30"
  records = [each.value.private_ip]
}
