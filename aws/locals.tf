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
}
