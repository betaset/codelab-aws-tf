locals {
  alb_path_pattern = "/${var.service}/*"
  alb_health_path = "/internal/health"
  log_group = "/ecs/${local.default_name}"
}
