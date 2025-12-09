data "aws_route53_zone" "default" {
  name = var.domain
}

data "aws_lb" "network" {
  name = "nginx-ingress-nlb"
}

resource "aws_route53_record" "clickhouse" {
  zone_id = data.aws_route53_zone.default.zone_id
  name    = "${var.redis_sub_domain}.${var.domain}"
  type    = "A"

  alias {
    name                   = data.aws_lb.network.dns_name
    zone_id                = data.aws_lb.network.zone_id
    evaluate_target_health = true
  }
}