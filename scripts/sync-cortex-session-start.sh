#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_file="${repo_root}/shared/cortex/session-start.md"
targets=(
  "${repo_root}/providers/codex/cortex/hooks/session-start.md"
  "${repo_root}/providers/claude/cortex/hooks/session-start.md"
  "${repo_root}/providers/gemini/cortex/hooks/session-start.md"
  "${repo_root}/providers/copilot/cortex/hooks/session-start.md"
)
cursor_target="${repo_root}/providers/cursor/cortex/hooks/session-start.json"

if [[ "${1:-}" == "--check" ]]; then
  for target in "${targets[@]}"; do
    if ! cmp -s "${source_file}" "${target}"; then
      echo "Out of sync: ${target#"${repo_root}/"}" >&2
      exit 1
    fi
  done
  node -e '
    const fs = require("node:fs");
    const [sourcePath, targetPath] = process.argv.slice(1);
    const source = fs.readFileSync(sourcePath, "utf8");
    const generated = JSON.parse(fs.readFileSync(targetPath, "utf8"));
    if (generated.additional_context !== source) {
      console.error(`Out of sync: ${targetPath}`);
      process.exit(1);
    }
  ' "${source_file}" "${cursor_target}"
  exit 0
fi

if [[ $# -ne 0 ]]; then
  echo "Usage: $0 [--check]" >&2
  exit 2
fi

for target in "${targets[@]}"; do
  cp "${source_file}" "${target}"
done

node -e '
  const fs = require("node:fs");
  const [sourcePath, targetPath] = process.argv.slice(1);
  const source = fs.readFileSync(sourcePath, "utf8");
  fs.writeFileSync(
    targetPath,
    `${JSON.stringify({ additional_context: source }, null, 2)}\n`,
  );
' "${source_file}" "${cursor_target}"
