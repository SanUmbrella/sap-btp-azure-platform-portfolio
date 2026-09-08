#!/usr/bin/env bash
set -euo pipefail

: "${AZURE_CLIENT_ID:?AZURE_CLIENT_ID must be supplied from fresh Terraform output}"

sed "s/\${AZURE_CLIENT_ID}/${AZURE_CLIENT_ID}/g" \
  "$(dirname "$0")/../kubernetes/serviceaccount.yaml"
