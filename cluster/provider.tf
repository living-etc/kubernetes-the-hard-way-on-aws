provider "kubernetes" {
  config_path = "../kubeconfig/admin.kubeconfig"
  host        = "${data.terraform_remote_state.compute.outputs.lb_dns_name}:6443"
  insecure    = true
}
