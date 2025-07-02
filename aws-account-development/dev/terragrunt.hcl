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
  # App inputs
  public_subnets = ["subnet-12345", "subnet-67890"]
  alb_sg         = "sg-alb123"
  vpc_id         = "vpc-12345"
  use_localstack = true
  
  # RDS inputs
  db_sg           = "sg-db123"
  private_subnets = ["subnet-private1", "subnet-private2"]
  kms_key_id      = "alias/aws/rds"
  
  # Redis inputs
  redis_subnet_group = "redis-subnet-group"
  redis_sg          = "sg-redis123"
  
  # Route53 inputs
  zone_id     = "Z123456789"
  namespace   = "dev"
  domain      = "example.com"
  lb_dns_name = "app-alb-123456789.us-east-1.elb.amazonaws.com"
  lb_zone_id  = "Z35SXDOTRQ7X7K"
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

