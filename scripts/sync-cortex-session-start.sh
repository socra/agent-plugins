#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_file="${repo_root}/shared/cortex/session-start.md"
targets=(
  "${repo_root}/providers/codex/cortex/hooks/session-start.md"
  "${repo_root}/providers/claude/cortex/hooks/session-start.md"
)

if [[ "${1:-}" == "--check" ]]; then
  for target in "${targets[@]}"; do
    if ! cmp -s "${source_file}" "${target}"; then
      echo "Out of sync: ${target#"${repo_root}/"}" >&2
      exit 1
    fi
  done
  exit 0
fi

if [[ $# -ne 0 ]]; then
  echo "Usage: $0 [--check]" >&2
  exit 2
fi

for target in "${targets[@]}"; do
  cp "${source_file}" "${target}"
done
