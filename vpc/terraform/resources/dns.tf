resource "aws_route53_zone" "main" {
  name = "${var.stage}.${local.dns_root_zone}"
}

output "hosted_zone_name" {
  value = aws_route53_zone.main.name
}
output "hosted_zone_id" {
  value = aws_route53_zone.main.id
}
output "hosted_zone_ns_servers" {
  value = aws_route53_zone.main.name_servers
}
