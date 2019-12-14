#! /usr/bin/env bash

set -eo pipefail

cd js
zip ../lambda.zip index.js
