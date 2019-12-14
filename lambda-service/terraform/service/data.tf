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
