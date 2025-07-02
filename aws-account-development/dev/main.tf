module "app" {
  source = "../../modules/app"
  
  public_subnets = var.public_subnets
  alb_sg         = var.alb_sg
  vpc_id         = var.vpc_id
  use_localstack = var.use_localstack
}

module "rds" {
  source = "../../modules/rds"
  
  db_sg           = var.db_sg
  private_subnets = var.private_subnets
  kms_key_id      = var.kms_key_id
}

module "redis" {
  source = "../../modules/redis"
  
  redis_subnet_group = var.redis_subnet_group
  redis_sg          = var.redis_sg
}

module "route53" {
  source = "../../modules/route53"
  
  zone_id     = var.zone_id
  namespace   = var.namespace
  domain      = var.domain
  lb_dns_name = var.lb_dns_name
  lb_zone_id  = var.lb_zone_id
}