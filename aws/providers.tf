provider "aws" {
  region = "eu-west-1"

  assume_role {
    role_arn = data.terraform_remote_state.organization.outputs.role_arns["KubernetesTheHardWay"]
  }
}
