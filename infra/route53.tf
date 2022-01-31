data "aws_route53_zone" "zone" {
  name = "${var.route53_hosted_zone_name}"
}

resource "aws_route53_record" "myapp" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.app_subdomain}.${var.route53_hosted_zone_name}"
  type    = "A"
  alias {
    name                   = "${aws_lb.versionn-app-alb.dns_name}"
    zone_id                = "${aws_lb.versionn-app-alb.zone_id}"
    evaluate_target_health = true
  }
}