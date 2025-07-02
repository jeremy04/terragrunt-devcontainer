variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "alb_sg" {
  description = "Security group ID for ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "use_localstack" {
  description = "Use LocalStack-compatible resources only"
  type        = bool
  default     = false
}

# RDS variables
variable "db_sg" {
  description = "Security group ID for database"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "kms_key_id" {
  description = "KMS Key ID for RDS encryption"
  type        = string
}

# Redis variables
variable "redis_subnet_group" {
  description = "Redis subnet group name"
  type        = string
}

variable "redis_sg" {
  description = "Security group ID for Redis"
  type        = string
}

# Route53 variables
variable "zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "namespace" {
  description = "Namespace for the application"
  type        = string
}

variable "domain" {
  description = "Domain name"
  type        = string
}

variable "lb_dns_name" {
  description = "Load balancer DNS name"
  type        = string
}

variable "lb_zone_id" {
  description = "Load balancer zone ID"
  type        = string
}