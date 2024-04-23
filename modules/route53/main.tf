resource "aws_route53_zone" "new_zone" {
  name = var.zone-name
}


resource "aws_route53_record" "bluecat495_record" {
  zone_id = aws_route53_zone.new_zone.zone_id
  name    = var.record-name
  type    = var.record-type
  ttl     = var.record-ttl

  records = var.record-records
}
