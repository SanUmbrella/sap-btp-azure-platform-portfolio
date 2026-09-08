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

strip_backend_blocks() {
  local module_path="$1"

  python3 - "$module_path" <<'PY'
from pathlib import Path
import re
import sys

module = Path(sys.argv[1])
pattern = re.compile(r'\n\s*backend\s+"s3"\s+\{\s*\}\n', re.MULTILINE)

for path in module.rglob("*.tf"):
    text = path.read_text(encoding="utf-8")
    updated = pattern.sub("\n", text)
    if updated != text:
        path.write_text(updated, encoding="utf-8")
PY
}

validate_module() {
  local module_path="$1"

  strip_backend_blocks "$module_path"
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
