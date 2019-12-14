locals {
  lambda_payload_file_name = "../../lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.default_name
  description = "Some fancy lambda function responding to your HTTP requests"
  filename = local.lambda_payload_file_name
  # make sure terraform updates the function on code changes
  source_code_hash = filebase64sha256(local.lambda_payload_file_name)

  role = aws_iam_role.function-execution.arn
  handler = "index.handler"
  runtime = "nodejs12.x"
  timeout = 3
  memory_size = 128

  lifecycle {
    create_before_destroy = true
  }

  tags = local.default_tags
}
