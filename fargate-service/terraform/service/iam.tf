# ECS needs to assume this role to perform fargate task launches
data "aws_iam_policy_document" "task-execution-assume-role" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        "ecs-tasks.amazonaws.com"]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole"]
  }
}

# permissions for the fargate task
data "aws_iam_policy_document" "task-execution" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      # allow pulling from ECR
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      # allow logging to cloudwatch
      "logs:CreateLogStream",
      "logs:PutLogEvents"]
    resources = [
      "*"]
  }
}

# this is the task execution role
resource "aws_iam_role" "task-execution" {
  name_prefix = "${local.default_name}-"
  assume_role_policy = data.aws_iam_policy_document.task-execution-assume-role.json
  tags = local.default_tags
}

resource "aws_iam_role_policy" "task-execution" {
  policy = data.aws_iam_policy_document.task-execution.json
  role = aws_iam_role.task-execution.id
}
