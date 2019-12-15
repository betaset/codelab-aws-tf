#!/usr/bin/env bash

git checkout .
rm -rf \
  lambda-service \
  fargate-service/terraform/service/cloudwatch.tf \
  pipeline-scripts/ci/build-js-lambda.sh
sed -i \
  -e 's/],/]/' \
  -e '/logConfiguration/,+7d' \
  fargate-service/terraform/service/service.json
