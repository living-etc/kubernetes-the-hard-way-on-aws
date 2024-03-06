resource "aws_instance" "controllers" {
  for_each                    = aws_subnet.my_subnets
  subnet_id                   = each.value.id
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  private_ip                  = "10.240.${each.key}.${1 + local.subnet_reserved_ips}"

  vpc_security_group_ids = [
    aws_security_group.instance.id
  ]

  tags = {
    Name = "controller-${each.key + 1}"
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_instance" "workers" {
  for_each                    = aws_subnet.my_subnets
  subnet_id                   = each.value.id
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  private_ip                  = "10.240.${each.key}.${2 + local.subnet_reserved_ips}"

  vpc_security_group_ids = [
    aws_security_group.instance.id
  ]

  tags = {
    Name = "worker-${each.key + 1}"
  }

  root_block_device {
    volume_size = 30
  }
}
