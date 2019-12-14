locals {
  # team name is prefixed to resource names to ensure uniqunes
  team = "betaset"

  # where we are deploying our stuff
  aws_region = "eu-central-1"

  # location of s3 bucket and dynamodb table for terraforms state bucket
  # do not use locals or variables here since this is evaluated by deployment script as well
  tfstate_bucket_name = "betaset-global-tfstate"
  tfstate_bucket_region = "eu-central-1"
  tfstate_dynamodb_table = "betaset-global-tfstate"

  default_name = "${var.stage}-${var.service}"
  dns_root_zone = "codelab.betaset.de"

  # tags applyed to all resources
  # merge with your service specific tags
  default_tags = {
    team = local.team
    service = var.service
    stage = var.stage
  }
}