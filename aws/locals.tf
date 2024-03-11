locals {
  vpc_cidr = "10.240.0.0/16"
  pod_cidr = "10.200.0.0/16"

  controllers = [
    { name = "controller-1", private_ip = "10.240.0.4" },
    { name = "controller-2", private_ip = "10.240.1.4" },
    { name = "controller-3", private_ip = "10.240.2.4" },
  ]

  workers = [
    { name = "worker-1", private_ip = "10.240.0.5", pod_cidr = "10.200.0.0/24", },
    { name = "worker-2", private_ip = "10.240.1.5", pod_cidr = "10.200.1.0/24", },
    { name = "worker-3", private_ip = "10.240.2.5", pod_cidr = "10.200.2.0/24", },
  ]

  security_group_rules = [
    {
      from_port   = 6443,
      to_port     = 6443,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
      type        = "ingress",
      description = "Allow traffic to the cluster endpoint from all sources."
    },
    {
      from_port   = 22,
      to_port     = 22,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
      type        = "ingress",
      description = "Allow SSH traffic from all sources."
    },
    {
      from_port   = 0,
      to_port     = 0,
      protocol    = "tcp",
      cidr_blocks = [local.vpc_cidr, local.pod_cidr],
      type        = "ingress",
      description = "Allow all internal traffic from both the node and pod networks"
    },
    {
      from_port   = 0,
      to_port     = 0,
      protocol    = "icmp",
      cidr_blocks = ["0.0.0.0/0"],
      type        = "ingress",
      description = "Allow all icmp traffic from all sources"
    },
    {
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"],
      type        = "egress",
      description = "Allow all egress traffic"
    },
  ]
}
