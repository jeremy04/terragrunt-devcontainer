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