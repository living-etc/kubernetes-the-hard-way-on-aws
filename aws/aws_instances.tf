resource "aws_instance" "controllers" {
  for_each = local.controllers

  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = aws_subnet.subnets[each.value.subnet].id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  private_ip                  = each.value.private_ip
  source_dest_check           = false

  vpc_security_group_ids = [
    aws_security_group.instance.id
  ]

  tags = {
    Name = each.value.name
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_instance" "workers" {
  for_each = local.workers

  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = aws_subnet.subnets[each.value.subnet].id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  private_ip                  = each.value.private_ip
  source_dest_check           = false

  vpc_security_group_ids = [
    aws_security_group.instance.id
  ]

  tags = {
    Name = each.value.name
  }

  root_block_device {
    volume_size = 30
  }
}
