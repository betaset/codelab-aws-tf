locals {
  # VPC settings
  cidr = "10.0.0.0/16"
  single_nat = var.stage != "prod" && var.stage != "live"

  # IP range allowed to connect to our external ALB
  # Allow all traffic for now
  alb_ingress_allow_cidr = "0.0.0.0/0"
}