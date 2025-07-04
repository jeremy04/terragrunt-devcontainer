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
  use_localstack = true
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
    apigateway     = "http://localstack:4566"
    apigatewayv2   = "http://localstack:4566"
    cloudformation = "http://localstack:4566"
    cloudwatch     = "http://localstack:4566"
    dynamodb       = "http://localstack:4566"
    ec2            = "http://localstack:4566"
    ecs            = "http://localstack:4566"
    iam            = "http://localstack:4566"
    lambda         = "http://localstack:4566"
    rds            = "http://localstack:4566"
    route53        = "http://localstack:4566"
    s3             = "http://localstack:4566"
    secretsmanager = "http://localstack:4566"
    ses            = "http://localstack:4566"
    sns            = "http://localstack:4566"
    sqs            = "http://localstack:4566"
    ssm            = "http://localstack:4566"
    sts            = "http://localstack:4566"
  }
}
EOF
}

