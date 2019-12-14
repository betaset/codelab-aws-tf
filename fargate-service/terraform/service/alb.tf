# each service gets its own ALB target group
resource "aws_alb_target_group" "service" {
  name = local.default_name
  protocol = "HTTP"
  port = 8080
  vpc_id = data.aws_vpc.main.id
  target_type = "ip"

  # time to wait for connectons to drain
  deregistration_delay = 10

  # configure http health checks
  health_check {
    path = local.alb_health_path
  }
}

# specify how our service is hooked into ALB
# we make use of path prefixes here
resource "aws_alb_listener_rule" "service" {
  listener_arn = data.aws_alb_listener.ingress.arn
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.service.arn
  }
  condition {
    field = "path-pattern"
    values = [
      local.alb_path_pattern]
  }
}
