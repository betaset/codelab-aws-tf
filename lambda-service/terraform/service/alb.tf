# each service gets its own ALB target group
resource "aws_lb_target_group" "lambda" {
  name = local.default_name
  target_type = "lambda"
  tags = local.default_tags
}

# attach the lambda function to the target group
resource "aws_lb_target_group_attachment" "lambda" {
  target_group_arn = aws_lb_target_group.lambda.arn
  target_id = aws_lambda_function.lambda.arn
  depends_on = [
    aws_lambda_permission.lambda]
}

# specify how our service is hooked into ALB
# we make use of path prefixes here
resource "aws_alb_listener_rule" "lambda" {
  listener_arn = data.aws_alb_listener.ingress.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lambda.arn
  }

  condition {
    field = "path-pattern"
    values = [
      local.alb_path_pattern]
  }
}

# allow ALB to invoke the lambda function
resource "aws_lambda_permission" "lambda" {
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = "elasticloadbalancing.amazonaws.com"
}
