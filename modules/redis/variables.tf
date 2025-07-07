variable "redis_subnet_group" {
  description = "Redis subnet group name"
  type        = string
}

variable "redis_sg" {
  description = "Security group ID for Redis"
  type        = string
}