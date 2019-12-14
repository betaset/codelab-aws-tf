# lambda needs to assume this role to perform function executions
data "aws_iam_policy_document" "function-execution-assume-role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        "lambda.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole"]
  }
}

# permissions for the lambda function
data "aws_iam_policy_document" "function-execution" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      # allow logging to cloudwatch
      "logs:CreateLogStream",
      "logs:PutLogEvents"]
    resources = [
      "*"]
  }
}

# this is the function execution role
resource "aws_iam_role" "function-execution" {
  name_prefix = "${local.default_name}-"
  assume_role_policy = data.aws_iam_policy_document.function-execution-assume-role.json
  tags = local.default_tags
}

resource "aws_iam_role_policy" "function-execution" {
  policy = data.aws_iam_policy_document.function-execution.json
  role = aws_iam_role.function-execution.id
}
