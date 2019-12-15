#!/usr/bin/env bash

git checkout .
rm -rf \
  fargate-service \
  lambda-service \
  vpc \
  pipeline-scripts/ci/build-js-lambda.sh \
  */terraform/*/shared_backend.tf
sed -i \
  -e '/backend-config/d' \
  -e 's/terraform init.*/terraform init/' \
  pipeline-scripts/ci/deploy-tf.sh
