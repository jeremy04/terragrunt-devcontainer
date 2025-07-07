
module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier        = "app-db"
  engine            = "postgres"
  engine_version    = "18.1"
  instance_class    = "db.t3.medium"
  allocated_storage = 20

  vpc_security_group_ids = [var.db_sg]
  subnet_ids             = var.private_subnets

  backup_window           = "03:00-04:00"
  backup_retention_period = 7
  maintenance_window      = "sun:04:00-sun:05:00"

  create_db_subnet_group        = true
  create_monitoring_role        = true
  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.kms_key_id
  
  family = "postgres18"
}
