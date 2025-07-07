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