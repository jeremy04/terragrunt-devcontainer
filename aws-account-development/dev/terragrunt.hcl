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
  region                      = "${local.region}"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    ecs            = "http://localhost:4566"
    iam            = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}
EOF
}

