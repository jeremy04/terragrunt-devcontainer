locals {
  shared_config = read_terragrunt_config(find_in_parent_folders("shared.hcl"))

  region         = local.shared_config.locals.region
  aws_profile    = local.shared_config.locals.aws_profile
  aws_account_id = local.shared_config.locals.aws_account_id
  env            = "dev"
}

terraform {
  source = "../../modules/app"
}

inputs = {
  public_subnets = ["subnet-12345", "subnet-67890"]
  alb_sg         = "sg-alb123"
  vpc_id         = "vpc-12345"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region  = "${local.region}"
  profile = "${local.aws_profile}"
}
EOF
}

