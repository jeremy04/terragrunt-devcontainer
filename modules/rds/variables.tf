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