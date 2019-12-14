locals {
  alb_ingress_dns_name = "www.${aws_route53_zone.main.name}"

  # full list of CIDR blocks allowed to connect to our ingress ALB
  alb_ingress_allow_cidr_full = concat([
    # allow requests from outside
    local.alb_ingress_allow_cidr],
  # allow requests from within VPCs private subnets
  formatlist("%s/32", module.vpc.nat_public_ips))
}

# define security group for our ALB
resource "aws_security_group" "alb-ingress" {
  name_prefix = "alb-ingress-${var.stage}-"
  description = "Manage ingress traffic for alb ${var.stage}}"

  # Connect SG to our VPC
  vpc_id = module.vpc.vpc_id

  # allow http access
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = local.alb_ingress_allow_cidr_full
  }
  # allow https access
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = local.alb_ingress_allow_cidr_full
  }

  # allow all outgoing
  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = local.default_tags
}

# define ALB itself
resource "aws_lb" "ingress" {
  name = "${var.stage}-${var.service}-ingress"

  internal = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb-ingress.id]
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = merge(local.default_tags, {
    external: true
  })
}

# ingress listener / ALB frontend
# serving static 404 as default response
resource "aws_alb_listener" "ingress_http_listener" {
  load_balancer_arn = aws_lb.ingress.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code = "404"
      message_body = "Not found"
    }
  }
}

resource "aws_route53_record" "ingress" {
  name = local.alb_ingress_dns_name
  type = "A"
  zone_id = aws_route53_zone.main.id

  alias {
    evaluate_target_health = false
    name = aws_lb.ingress.dns_name
    zone_id = aws_lb.ingress.zone_id
  }
}

output "alb_ingress_dns_name" {
  value = aws_route53_record.ingress.name
}
