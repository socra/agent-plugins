#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_file="${repo_root}/shared/cortex/session-start.md"
max_context_bytes=2000
targets=(
  "${repo_root}/providers/codex/cortex/hooks/session-start.md"
  "${repo_root}/providers/claude/cortex/hooks/session-start.md"
  "${repo_root}/providers/copilot/cortex/hooks/session-start.md"
)
cursor_target="${repo_root}/providers/cursor/cortex/hooks/session-start.json"
codex_hooks="${repo_root}/providers/codex/cortex/hooks/hooks.json"
codex_trust="${repo_root}/providers/codex/cortex/hooks/trust.json"

validate_source_size() {
  local source_bytes
  source_bytes="$(wc -c < "${source_file}" | tr -d ' ')"
  if (( source_bytes > max_context_bytes )); then
    echo "Session-start context is ${source_bytes} bytes; maximum is ${max_context_bytes}: ${source_file}" >&2
    exit 1
  fi
}

sync_codex_trust() {
  local mode="$1"
  node - "${codex_hooks}" "${codex_trust}" "${mode}" <<'NODE'
const crypto = require('node:crypto');
const fs = require('node:fs');

const [hooksPath, trustPath, mode] = process.argv.slice(2);
const document = JSON.parse(fs.readFileSync(hooksPath, 'utf8'));
const groups = document?.hooks?.SessionStart;

if (!Array.isArray(groups) || groups.length !== 1) {
  throw new Error('Codex must declare exactly one SessionStart matcher group');
}

const group = groups[0];
if (!Array.isArray(group?.hooks) || group.hooks.length !== 1) {
  throw new Error('Codex must declare exactly one SessionStart hook');
}

const hook = group.hooks[0];
if (hook?.type !== 'command' || typeof hook.command !== 'string') {
  throw new Error('Codex SessionStart must be a command hook');
}

const normalizedHook = {
  type: 'command',
  command: hook.command,
  timeout: hook.timeout ?? 600,
  async: hook.async ?? false,
  ...(hook.statusMessage === undefined ? {} : { statusMessage: hook.statusMessage }),
  ...(hook.additionalContextLimit === undefined
    ? {}
    : { additionalContextLimit: hook.additionalContextLimit }),
  ...(hook.commandWindows === undefined ? {} : { commandWindows: hook.commandWindows }),
};
const identity = {
  event_name: 'session_start',
  ...(group.matcher === undefined ? {} : { matcher: group.matcher }),
  hooks: [normalizedHook],
};
const canonicalize = value => {
  if (Array.isArray(value)) return value.map(canonicalize);
  if (value && typeof value === 'object') {
    return Object.fromEntries(
      Object.keys(value)
        .sort()
        .map(key => [key, canonicalize(value[key])]),
    );
  }
  return value;
};
const currentHash = `sha256:${crypto
  .createHash('sha256')
  .update(JSON.stringify(canonicalize(identity)))
  .digest('hex')}`;
const generated = {
  key: 'cortex@socra:hooks/hooks.json:session_start:0:0',
  currentHash,
};

if (mode === 'check') {
  const existing = JSON.parse(fs.readFileSync(trustPath, 'utf8'));
  if (JSON.stringify(existing) !== JSON.stringify(generated)) {
    console.error(`Out of sync: ${trustPath}`);
    process.exit(1);
  }
} else {
  fs.writeFileSync(trustPath, `${JSON.stringify(generated, null, 2)}\n`);
}
NODE
}

validate_source_size

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
  sync_codex_trust check
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

sync_codex_trust write
