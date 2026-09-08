#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.."
  pwd
)"

TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

copy_module() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"
  cp -R "$source_path" "$target_path"
}

validate_module() {
  local module_path="$1"

  printf '\n==> terraform validate %s\n' "$module_path"
  terraform -chdir="$module_path" init -backend=false -input=false >/dev/null
  terraform -chdir="$module_path" validate
}

copy_module "$ROOT/examples/terraform" "$TMP_DIR/examples/terraform"
copy_module "$ROOT/cf-provider-reproducer" "$TMP_DIR/cf-provider-reproducer"
copy_module "$ROOT/reference-implementation/sap-btp" "$TMP_DIR/reference-implementation/sap-btp"
copy_module "$ROOT/reference-implementation/azure/terraform" "$TMP_DIR/reference-implementation/azure/terraform"

validate_module "$TMP_DIR/examples/terraform"
validate_module "$TMP_DIR/cf-provider-reproducer"
validate_module "$TMP_DIR/reference-implementation/sap-btp/terraform"
validate_module "$TMP_DIR/reference-implementation/azure/terraform"
