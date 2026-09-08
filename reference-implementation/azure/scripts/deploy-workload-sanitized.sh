#!/usr/bin/env bash
set -Eeuo pipefail

REPO_ROOT="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../../.."
  pwd
)"

cd "$REPO_ROOT/reference-implementation/azure"

: "${AZURE_CLIENT_ID:?Set from fresh Terraform output}"
: "${ACR_LOGIN_SERVER:?Set from fresh Terraform output or Azure CLI lookup}"
: "${KEYVAULT_URL:?Set from fresh Terraform output}"
: "${IMAGE_TAG:=v1}"

PLATFORM_NAMESPACE="platform-lab"
SERVICE_ACCOUNT="kv-reader"
IMAGE="${ACR_LOGIN_SERVER}/aks-probe-api:${IMAGE_TAG}"

log() {
  printf "\n==> %s\n" "$*"
}

fail() {
  printf "ERROR: %s\n" "$*" >&2
  exit 1
}

for command in kubectl envsubst docker; do
  command -v "$command" >/dev/null 2>&1 ||
    fail "Required command not found: $command"
done

log "Rendering Workload Identity ServiceAccount"
export AZURE_CLIENT_ID
envsubst < kubernetes/serviceaccount.yaml > /tmp/platform-lab-serviceaccount.yaml

if grep -q '\${AZURE_CLIENT_ID}' /tmp/platform-lab-serviceaccount.yaml; then
  fail "AZURE_CLIENT_ID remained unresolved in ServiceAccount manifest"
fi

kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f /tmp/platform-lab-serviceaccount.yaml

K8S_CLIENT_ID="$(
  kubectl get serviceaccount \
    --namespace "$PLATFORM_NAMESPACE" \
    "$SERVICE_ACCOUNT" \
    -o jsonpath='{.metadata.annotations.azure\.workload\.identity/client-id}'
)"

[[ "$K8S_CLIENT_ID" == "$AZURE_CLIENT_ID" ]] ||
  fail "Terraform and Kubernetes Workload Identity client IDs differ"

log "Building probe image"
docker build --tag "$IMAGE" probe-api

log "Rendering probe deployment"
export IMAGE
export KEYVAULT_URL
envsubst < kubernetes/probe-api.yaml > /tmp/aks-probe-api.yaml

if grep -Eq '\$\{(IMAGE|KEYVAULT_URL)\}' /tmp/aks-probe-api.yaml; then
  fail "Unresolved variable remained in Deployment manifest"
fi

kubectl apply -f /tmp/aks-probe-api.yaml

kubectl rollout status \
  --namespace "$PLATFORM_NAMESPACE" \
  deployment/aks-probe-api \
  --timeout=300s

printf "\nAKS workload deployment completed with sanitized runtime inputs.\n"
