# log application logs into cloudwatch logs
resource "aws_cloudwatch_log_group" "service" {
  name = local.log_group
  retention_in_days = 7
  tags = local.default_tags
}