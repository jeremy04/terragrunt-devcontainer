
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = "app-redis"
  replication_group_description = "Redis for Sidekiq"
  node_type                     = "cache.t3.micro"
  num_cache_clusters            = 1
  engine                        = "redis"
  automatic_failover_enabled    = false
  subnet_group_name             = var.redis_subnet_group
  security_group_ids            = [var.redis_sg]
}
