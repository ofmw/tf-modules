resource "aws_route53_record" "route53_record" {
  zone_id = var.zone-id
  name    = var.record-name
  type    = var.record-type
  ttl     = var.record-ttl

  records = [var.record-records]
}
