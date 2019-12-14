terraform {
  # Empty backend config.
  # All keys are set from deployment script.
  # Read more details here: https://www.terraform.io/docs/backends/config.html
  # and here https://www.terraform.io/docs/backends/types/s3.html
  #
  # Backend config for tfstate is special:
  # 1. Strip the backend config for initial deployment to make terraform use a local state
  # 2. Revert changes and deploy again. Terraform will ask for moving the state to S3.
  backend "s3" {
    encrypt = true
  }
}