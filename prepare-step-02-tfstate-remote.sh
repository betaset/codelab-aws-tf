#!/usr/bin/env bash

git checkout .
rm -rf \
  fargate-service \
  lambda-service \
  vpc \
  pipeline-scripts/ci/build-js-lambda.sh
