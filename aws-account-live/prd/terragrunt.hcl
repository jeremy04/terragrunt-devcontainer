locals {
  shared_config = read_terragrunt_config(find_in_parent_folders("shared.hcl"))

  region         = local.shared_config.locals.region
  aws_profile    = local.shared_config.locals.aws_profile
  aws_account_id = local.shared_config.locals.aws_account_id
  env            = "prd"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region  = "${local.region}"
  profile = "${local.aws_profile}"

  assume_role {
    role_arn = "arn:aws:iam::${local.aws_account_id}:role/TerraformRole"
  }
}
EOF
}
