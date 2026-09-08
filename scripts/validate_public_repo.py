#!/usr/bin/env python3
"""Conservative public-repository safety checks.

The checks are intentionally static and local. They are designed to catch common
accidental leaks in a sanitized architecture portfolio without requiring any
external service or heavyweight dependency.
"""

from __future__ import annotations

import os
import json
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

TEXT_EXTENSIONS = {
    ".md",
    ".txt",
    ".tf",
    ".yaml",
    ".yml",
    ".json",
    ".py",
    ".sh",
    ".go",
    ".mod",
    ".sum",
    ".hcl",
    ".tmpl",
    ".gitignore",
}

FORBIDDEN_EXACT_NAMES = {
    ".env",
    "credentials",
    "secrets",
    "kubeconfig",
}

FORBIDDEN_SUFFIXES = {
    ".tfstate",
    ".tfplan",
    ".plan",
    ".pem",
    ".key",
    ".pfx",
    ".p12",
    ".kubeconfig",
}

SKIP_DIRS = {
    ".git",
    ".agents",
    ".codex",
    "__pycache__",
}

SAFE_EXAMPLE_LITERALS = {
    "${AZURE_CLIENT_ID}",
    "${OIDC_ISSUER_URL}",
    "${NAMESPACE}",
    "${SERVICE_ACCOUNT_NAME}",
    "${REMOTE_URL}",
}

TEXT_FILENAMES = {
    "Dockerfile",
}


CHECKS = [
    (
        "uuid-looking value",
        re.compile(
            r"\b[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-"
            r"[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\b"
        ),
    ),
    ("private key header", re.compile(r"BEGIN [A-Z ]*PRIVATE KEY")),
    ("aws-style access key", re.compile(r"\b(AKIA|ASIA)[0-9A-Z]{16}\b")),
    (
        "non-example email address",
        re.compile(r"\b(?!example(?:\.com)?\b)[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b"),
    ),
    (
        "literal client secret assignment",
        re.compile(r"\bclient_secret\b\s*[:=]\s*[\"'](?!<|\$\{)[^\"']{6,}[\"']", re.IGNORECASE),
    ),
    (
        "literal password assignment",
        re.compile(r"\bpassword\b\s*[:=]\s*[\"'](?!<|\$\{)[^\"']{6,}[\"']", re.IGNORECASE),
    ),
    (
        "literal token assignment",
        re.compile(r"\b(?:token|tunnel_token|access_token)\b\s*[:=]\s*[\"'](?!<|\$\{)[^\"']{8,}[\"']", re.IGNORECASE),
    ),
]


def tracked_files() -> list[Path]:
    try:
        result = subprocess.run(
            ["git", "ls-files"],
            cwd=ROOT,
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        result = None

    if result and result.stdout.strip():
        return [ROOT / line for line in result.stdout.splitlines()]

    files: list[Path] = []
    for directory, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [name for name in dirnames if name not in SKIP_DIRS]
        for filename in filenames:
            files.append(Path(directory) / filename)
    return sorted(files)


def is_text_file(path: Path) -> bool:
    if path.name in TEXT_FILENAMES:
        return True
    if path.name == ".gitignore":
        return True
    return path.suffix.lower() in TEXT_EXTENSIONS


def binary_file_reason(path: Path) -> str | None:
    try:
        header = path.read_bytes()[:4]
    except OSError:
        return None
    if header == b"\x7fELF":
        return "compiled ELF binary is not allowed"
    return None


def forbidden_path_reason(path: Path) -> str | None:
    name = path.name.lower()
    if name in FORBIDDEN_EXACT_NAMES:
        return f"forbidden file name: {path.name}"
    if any(name.endswith(suffix) for suffix in FORBIDDEN_SUFFIXES):
        return f"forbidden file suffix: {path.name}"
    if name.startswith(".env."):
        return f"forbidden environment file: {path.name}"
    if name.startswith("credentials.") or name.startswith("secrets."):
        return f"forbidden credential-like file: {path.name}"
    return None


def scan_text(path: Path) -> list[str]:
    try:
        text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return []

    findings: list[str] = []
    for label, pattern in CHECKS:
        for match in pattern.finditer(text):
            value = match.group(0)
            if value in SAFE_EXAMPLE_LITERALS:
                continue
            line_no = text.count("\n", 0, match.start()) + 1
            findings.append(f"{path.relative_to(ROOT)}:{line_no}: {label}: {value[:80]}")
    return findings


def parse_structured_file(path: Path) -> list[str]:
    try:
        if path.suffix.lower() == ".json":
            json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001 - report parse failures uniformly.
        return [f"{path.relative_to(ROOT)}: parse failed: {exc}"]
    return []


def main() -> int:
    failures: list[str] = []

    for path in tracked_files():
        if not path.is_file():
            continue
        relative = path.relative_to(ROOT)
        binary_reason = binary_file_reason(path)
        if binary_reason:
            failures.append(f"{relative}: {binary_reason}")
            continue
        reason = forbidden_path_reason(path)
        if reason:
            failures.append(f"{relative}: {reason}")
            continue
        if is_text_file(path):
            failures.extend(scan_text(path))
            failures.extend(parse_structured_file(path))

    if failures:
        print("Public repository validation failed:")
        for failure in failures:
            print(f"  - {failure}")
        return 1

    print("Public repository validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
