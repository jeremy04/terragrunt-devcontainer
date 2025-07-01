
resource "aws_route53_record" "app" {
  zone_id = var.zone_id
  name    = "app-${var.namespace}.${var.domain}"
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}
