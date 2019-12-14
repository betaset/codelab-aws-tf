# the ECS cluster all tasks are run in
resource "aws_ecs_cluster" "main" {
  name = local.default_name
  tags = local.default_tags
}

# provide a default security group for all tasks
# this SG allows VPC internal traffic and all outgoing traffic
resource "aws_security_group" "ecs-default" {
  name = "${local.default_name}-default"
  description = "Allow outgoing traffic and VPC internal traffic"

  # Connect SG to our VPC
  vpc_id = module.vpc.vpc_id

  # allow VPC internal traffic
  ingress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      module.vpc.vpc_cidr_block]
  }

  # allow all outgoing
  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = local.default_tags
}
