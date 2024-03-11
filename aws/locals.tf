locals {
  aws_region = "eu-west-1"
  vpc_cidr   = "10.240.0.0/16"
  pod_cidr   = "10.200.0.0/16"

  subnets = {
    "eu-west-1a" = { name = "eu-west-1a", cidr_block = "10.240.0.0/24" }
    "eu-west-1b" = { name = "eu-west-1b", cidr_block = "10.240.1.0/24" }
    "eu-west-1c" = { name = "eu-west-1c", cidr_block = "10.240.2.0/24" }
  }

  controllers = {
    "controller-1" = { name = "controller-1", private_ip = "10.240.0.4", subnet = "eu-west-1a" },
    "controller-2" = { name = "controller-2", private_ip = "10.240.1.4", subnet = "eu-west-1b" },
    "controller-3" = { name = "controller-3", private_ip = "10.240.2.4", subnet = "eu-west-1c" },
  }

  workers = {
    "worker-1" = { name = "worker-1", private_ip = "10.240.0.5", pod_cidr = "10.200.0.0/24", subnet = "eu-west-1a" },
    "worker-2" = { name = "worker-2", private_ip = "10.240.1.5", pod_cidr = "10.200.1.0/24", subnet = "eu-west-1b" },
    "worker-3" = { name = "worker-3", private_ip = "10.240.2.5", pod_cidr = "10.200.2.0/24", subnet = "eu-west-1c" },
  }

  security_group_rules = {
    "ingress-allow-all-port-6443" = { from_port = 6443, to_port = 6443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], type = "ingress", description = "Allow traffic to the cluster endpoint from all sources." },
    "ingress-allow-all-port-22"   = { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], type = "ingress", description = "Allow SSH traffic from all sources." },
    "ingress-allow-all-internal"  = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = [local.vpc_cidr, local.pod_cidr], type = "ingress", description = "Allow all internal traffic from both the node and pod networks" },
    "ingress-allow-all-icmp"      = { from_port = 0, to_port = 0, protocol = "icmp", cidr_blocks = ["0.0.0.0/0"], type = "ingress", description = "Allow all icmp traffic from all sources" },
    "egress-allow-all"            = { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], type = "egress", description = "Allow all egress traffic" },
  }
}
