# log application logs into cloudwatch logs
resource "aws_cloudwatch_log_group" "service" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = 7
  tags = local.default_tags
}