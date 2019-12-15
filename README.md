# AWS Terraform Codelab

Primary focus of this codelab is gathering initial knowledge about AWS and terraform.

## Content

Each main directory (except `/docker`) in this repository is meant as a project of its own.
You would want to split these into different git repos in a real world scenario.

Each project contains possibly multiple terraform projects called `deployment`.
Splitting up the terraform code into multiple parts (`deployment`s) is best practice.
It makes handling changes easier and keeps everything small and simple.

Here, terraform projects are split in the following deployments:

0. `resources` holding everything having state or necessary for outside communication.
  Examples are S3 buckets, DynamoDB tables, hosted zones.
0. `service` the stateless part of a service.
  Examples are ECS service/task, EC2 auto scaling groups, lambda functions.

The idea is, to be able to destroy the service completely without loosing data.

There might be more deployments in real world, such as:

0. `init` or `bootstrap` providing something like codecommit or ECR repositories for a service.
0. `shared` or `infrastructure` providing some kind of shared resources for all stages.

### pipeline-scripts

This is a set of shared scripts and terraform files.
They are shared as symlinks here.
You would want to build a cron job / pipeline deploying the content of this project to the others in a real world scenario.

### tfstate

Terraform keeps a so called state about what is deployed into the world.
There are a bunch of options for storing the terraform state.
When using terraform with AWS, S3 and DynamoDB are preferred.

We will deploy a S3 bucket for storing the state and
a DynamoDB table for holding locks to prevent concurrent deployments of single projects.

There should only be a single tfstate instance shared for all subsequent terraform projects.

### vpc

Most AWS resources live inside a VPC, a virtual private cloud.

We will deploy the following things shared across all your services:
 * the VPC with network configuration and other basic infrastructure
 * a DNS zone hosting
 * an ALB as central ingress point for HTTP and HTTPS traffic
 * an ECS cluster holding your fargate services

### fargate-service

This is a sample web service running in docker.

We will deploy the docker container with fargate
and manage HTTP routing to forward requests from ALB to the service.
Application logging is configured with cloudwatch logs.

### lambda-service

This is a sample web service running in lambda with nodejs.

We will deploy the lambda function
and manage HTTP routing to forward request from ALB to the service.
Application logging is configured with cloudwatch logs.

## Deployment

Each project in this repository brings a `ci/deploy-tf.sh`.
It will help you deploy the project to AWS.
Run `ci/deploy-tf.sh` to find more details.

Run `ci/deploy-tf.sh <stage> <deployment>` to run `terraform apply` for the given project.
`stage` is a well known name like `prod`,`live`, `develop` or `playground`.
It allows having multiple instances of the same resources.
`deployment` is something like `resources` or `service` as explained above.

### Igor

There is an [igor](https://github.com/felixb/igor) config in this repo.
Igor makes it very simple to share a set of tools with the help of docker.
You may want to install [igor](https://github.com/felixb/igor) and launch it in this repo to spawn a shell inside a docker container bringing all the tools needed.

## Further reading

* [terraform](https://www.terraform.io/)
* [terraform aws provider](https://www.terraform.io/docs/providers/aws/)
* [terraform backend config](https://www.terraform.io/docs/backends/config.html)
* [terraform s3 backend](https://www.terraform.io/docs/backends/types/s3.html)
* [igor](https://github.com/felixb/igor)
* [swamp](https://github.com/felixb/swamp)