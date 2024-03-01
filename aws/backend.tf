terraform {
  backend "s3" {
    region = "eu-west-1"
    key    = "kubernetes-the-hard-way-on-aws/terraform.tfstate"
    bucket = "chris-wilson-terraform-remote-state"
  }
}
