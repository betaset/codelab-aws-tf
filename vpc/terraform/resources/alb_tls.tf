resource "aws_acm_certificate" "alb_ingress" {
  domain_name = local.alb_ingress_dns_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = local.default_tags
}

resource "aws_route53_record" "alb_ingress_cert_validation" {
  name = aws_acm_certificate.alb_ingress.domain_validation_options[0].resource_record_name
  type = aws_acm_certificate.alb_ingress.domain_validation_options[0].resource_record_type
  zone_id = aws_route53_zone.main.id
  records = [
    aws_acm_certificate.alb_ingress.domain_validation_options[0].resource_record_value]
  ttl = 60
}

resource "aws_acm_certificate_validation" "alb_ingress_cert_validation" {
  certificate_arn = aws_acm_certificate.alb_ingress.arn
  validation_record_fqdns = [
    aws_route53_record.alb_ingress_cert_validation.fqdn]
}

resource "aws_alb_listener" "secure_listener" {
  load_balancer_arn = aws_lb.ingress.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-FS-2018-06"
  certificate_arn = aws_acm_certificate.alb_ingress.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code = "404"
      message_body = "Not found"
    }
  }
}
