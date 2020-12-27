resource "aws_acm_certificate" "practice" {
  domain_name = aws_route53_record.practice.name
  subject_alternative_names = []
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "practice_certificate" {
  name    = tolist(aws_acm_certificate.practice.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.practice.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.practice.domain_validation_options)[0].resource_record_value]
  zone_id = data.aws_route53_zone.practice.id
  ttl     = 60
}

resource "aws_acm_certificate_validation" "practice" {
  certificate_arn         = aws_acm_certificate.practice.arn
  validation_record_fqdns = [aws_route53_record.practice_certificate.fqdn]
}