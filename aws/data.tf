data "terraform_remote_state" "organization" {
  backend = "s3"

  config = {
    bucket = "chris-wilson-terraform-remote-state"
    key    = "component-library/000-aws-organisation.tfstate"
    region = "eu-west-1"
  }
}

data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
