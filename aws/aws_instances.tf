resource "aws_instance" "controllers" {
  count                       = length(aws_subnet.my_subnets.*.id)
  subnet_id                   = aws_subnet.my_subnets[count.index].id
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  private_ip                  = "10.240.${count.index}.${1 + local.subnet_reserved_ips}"

  vpc_security_group_ids = [
    aws_security_group.instance.id
  ]

  tags = {
    Name = "controller-${count.index + 1}"
  }

  root_block_device {
    volume_size = 30
  }
}

resource "aws_instance" "workers" {
  count                       = length(aws_subnet.my_subnets.*.id)
  subnet_id                   = aws_subnet.my_subnets[count.index].id
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.medium"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  private_ip                  = "10.240.${count.index}.${2 + local.subnet_reserved_ips}"

  vpc_security_group_ids = [
    aws_security_group.instance.id
  ]

  tags = {
    Name = "worker-${count.index + 1}"
  }

  root_block_device {
    volume_size = 30
  }
}
