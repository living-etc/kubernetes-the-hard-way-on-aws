data "terraform_remote_state" "compute" {
  backend = "s3"

  config = {
    key    = "kubernetes-the-hard-way-on-aws/terraform.tfstate"
    bucket = "chris-wilson-terraform-remote-state"
    region = "eu-west-1"
  }
}
