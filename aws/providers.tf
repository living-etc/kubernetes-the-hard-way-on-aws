provider "aws" {
  region = local.aws_region

  assume_role {
    role_arn = data.terraform_remote_state.organization.outputs.role_arns["KubernetesTheHardWay"]
  }
}
