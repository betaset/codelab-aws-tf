#!/usr/bin/env bash

git checkout .
rm -rf \
  fargate-service \
  lambda-service \
  vpc/terraform/resources/ecs.tf \
  vpc/terraform/resources/alb_tls.tf \
  pipeline-scripts/ci/build-js-lambda.sh
