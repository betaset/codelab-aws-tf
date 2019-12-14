#! /usr/bin/env bash

set -eo pipefail
SCRIPT_DIR=$(dirname "${0}")

if [[ $# -lt 2 ]]; then
  echo "usage: ${0} [--destroy|--dry-run] <stage> <deployment> [extra-tf-args...]"
  echo "      --destroy:        destroy all resources"
  echo "      --dry-run:        sho resources which need to be updated"
  echo "        stage:          nonlive, live, infrastructure or similar"
  echo "        deployment:     dir in /terraform"
  echo "        extra-tf-args:  something like '-var version=foo'"
  exit 1
fi

if [[ "${1}" == '--destroy' ]]; then
  TF_COMMAND='destroy'
  shift
elif [[ "${1}" == '--dry-run' ]] || [[ -n "${DRY_RUN}" ]]; then
  TF_COMMAND='plan'
  shift
else
  TF_COMMAND='apply -input=false -auto-approve'
fi

STAGE="${1}"
shift
DEPLOYMENT="${1}"
shift
TF_EXTRA_ARGS=("${@}")
SERVICE=$(basename "${PWD}")
TFSTATE_BUCKET_NAME=$(grep 'tfstate_bucket_name' "terraform/${DEPLOYMENT}/shared_constants.tf" | cut -d\" -f2)
TFSTATE_BUCKET_REGION=$(grep 'tfstate_bucket_region' "terraform/${DEPLOYMENT}/shared_constants.tf" | cut -d\" -f2)
TFSTATE_BUCKET_KEY="${SERVICE}-${DEPLOYMENT}.json"
TFSTATE_DYNAMODB_TABLE=$(grep 'tfstate_dynamodb_table' "terraform/${DEPLOYMENT}/shared_constants.tf" | cut -d\" -f2)

cd "${SCRIPT_DIR}/../terraform/${DEPLOYMENT}"

terraform init \
  -backend-config="bucket=${TFSTATE_BUCKET_NAME}" \
  -backend-config="region=${TFSTATE_BUCKET_REGION}" \
  -backend-config="key=${TFSTATE_BUCKET_KEY}" \
  -backend-config="dynamodb_table=${TFSTATE_DYNAMODB_TABLE}"
terraform workspace select "${STAGE}" || terraform workspace new "${STAGE}"
terraform ${TF_COMMAND} -var "service=${SERVICE}" -var "stage=${STAGE}" "${TF_EXTRA_ARGS[@]}"
