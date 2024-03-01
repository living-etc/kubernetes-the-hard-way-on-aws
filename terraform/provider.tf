provider "kubernetes" {
  config_path = "../kubeconfig/admin.kubeconfig"
  host        = "controllers-d5c5cdb3d63d5b2f.elb.eu-west-1.amazonaws.com:6443"
  insecure    = true
}
