data "aws_ecs_cluster" "main" {
  cluster_name = "${var.stage}-vpc"
}
data "aws_alb" "ingress" {
  name = "${var.stage}-vpc-ingress"
}
data "aws_alb_listener" "ingress" {
  load_balancer_arn = data.aws_alb.ingress.arn
  port = 80
}

data "aws_vpc" "main" {
  tags = {
    Name = "${var.stage}-vpc"
  }
}
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    private = true
  }
}

data "aws_security_group" "ecs-default" {
  name = "${var.stage}-vpc-default"
}