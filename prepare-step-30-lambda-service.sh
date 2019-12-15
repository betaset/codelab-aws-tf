#!/usr/bin/env bash

git checkout .
rm -f \
  lambda-service/terraform/service/alb.tf \
  lambda-service/terraform/service/cloudwatch.tf
