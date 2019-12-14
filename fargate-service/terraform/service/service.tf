# replace some parameters in service.json
data "template_file" "service-definition" {
  template = file("service.json")
  vars = {
    LOG_GROUP = local.log_group
    AWS_REGION = local.aws_region
  }
}

# define the fargate task
resource "aws_ecs_task_definition" "service" {
  family = local.default_name
  requires_compatibilities = [
    "FARGATE"]
  network_mode = "awsvpc"
  container_definitions = data.template_file.service-definition.rendered
  execution_role_arn = aws_iam_role.task-execution.arn

  # specify cpu in x/1024 shares
  cpu = 256
  # specify memory in megabytes
  memory = 512

  tags = local.default_tags
}

# define the fargate service
# which launches the task on given cluster
resource "aws_ecs_service" "service" {
  name = local.default_name
  cluster = data.aws_ecs_cluster.main.id
  launch_type = "FARGATE"
  task_definition = aws_ecs_task_definition.service.arn

  desired_count = 1

  network_configuration {
    subnets = data.aws_subnet_ids.private.ids
    security_groups = [
      data.aws_security_group.ecs-default.id]
  }

  # hook service into our ALB
  load_balancer {
    target_group_arn = aws_alb_target_group.service.arn
    container_name = "service"
    container_port = 8080
  }
}
