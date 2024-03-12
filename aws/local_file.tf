resource "local_file" "ssh_config" {
  filename             = "../ssh/config"
  directory_permission = "0755"
  file_permission      = "0644"
  content = templatefile("${path.module}/ssh_config.ini.tpl", {
    workers = [for instance in aws_instance.workers :
      {
        name = instance.tags["Name"]
        ip   = instance.public_ip
      }
    ]
    controllers = [for instance in aws_instance.controllers :
      {
        name = instance.tags["Name"]
        ip   = instance.public_ip
      }
    ]
  })
}

resource "local_file" "ansible_inventory" {
  filename             = "../ansible/inventory.ini"
  directory_permission = "0755"
  file_permission      = "0644"
  content = templatefile("${path.module}/ansible_inventory.ini.tpl", {
    workers = [for instance in aws_instance.workers :
      {
        name = instance.tags["Name"]
        ip   = instance.public_ip
      }
    ]
    controllers = [for instance in aws_instance.controllers :
      {
        name = instance.tags["Name"]
        ip   = instance.public_ip
      }
    ]
  })
}

resource "local_file" "ansible_vars_from_terraform" {
  filename             = "../ansible/vars-from-terraform.yaml"
  directory_permission = "0755"
  file_permission      = "0644"
  content = templatefile("${path.module}/vars-from-terraform.yaml.tpl", {
    controllers_lb_hostname = aws_lb.alb.dns_name
  })
}
