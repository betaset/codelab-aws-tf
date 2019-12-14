data "aws_availability_zones" "current" {}

# define VPC by unsing the terraform aws vpc module
# read all details here: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = local.default_name
  azs = data.aws_availability_zones.current.names

  # define IP adress ranges for VPC
  cidr = local.cidr
  # .. public subnets
  public_subnets = [
    cidrsubnet(local.cidr, 4, 0),
    cidrsubnet(local.cidr, 4, 1),
    cidrsubnet(local.cidr, 4, 2)]
  # .. and private subnets
  private_subnets = [
    cidrsubnet(local.cidr, 4, 8),
    cidrsubnet(local.cidr, 4, 9),
    cidrsubnet(local.cidr, 4, 10)]

  # fetch private IP within the VPC
  enable_dns_hostnames = true
  enable_dns_support = true
  # activate internet access within private subnet
  enable_nat_gateway = true
  one_nat_gateway_per_az = true
  # deploy one nat gateway for each AZ in production
  # deploy a single nat gateway in non production stages to save some money
  single_nat_gateway = local.single_nat

  # enable s3/dynamodb endpoint to directly communicate from vpc to global s3/dynamodb
  enable_s3_endpoint = true
  enable_dynamodb_endpoint = true

  # these tags allow easy subnet selection in later terraform projects
  public_subnet_tags = {
    public = true
    private = false
  }
  private_subnet_tags = {
    public = false
    private = true
  }

  tags = local.default_tags
}