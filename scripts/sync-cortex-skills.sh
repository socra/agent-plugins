#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 1 || ( $# -eq 1 && "$1" != "--check" ) ]]; then
  echo "Usage: $0 [--check]" >&2
  exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="${repo_root}/shared/cortex/skills/socra-cortex"
source_file="${source_dir}/SKILL.md"
# Add providers here only after their skill packaging has been validated.
targets=(
  "${repo_root}/providers/codex/cortex/skills/socra-cortex"
  "${repo_root}/providers/grok/cortex/skills/socra-cortex"
)

# The shared description uses a JSON-quoted YAML string so Node can validate it
# without introducing a YAML dependency into this repository.
node - "${source_file}" <<'NODE'
const fs = require('node:fs');
const source = fs.readFileSync(process.argv[2], 'utf8');
const frontmatter = source.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n/);
if (!frontmatter || !/^name: socra-cortex$/m.test(frontmatter[1])) {
  throw new Error('Cortex skill requires YAML frontmatter with name: socra-cortex');
}
const match = frontmatter[1].match(/^description: (".*")$/m);
if (!match) throw new Error('Use a single JSON-quoted description line');
const description = JSON.parse(match[1]);
const length = Array.from(description).length;
if (!description.trim() || length > 1024) {
  throw new Error(`Skill description must be 1–1024 characters; got ${length}`);
}
console.log(`Cortex skill description: ${length}/1024 characters`);
NODE

for target_dir in "${targets[@]}"; do
  for file in SKILL.md agents/openai.yaml; do
    source="${source_dir}/${file}"
    target="${target_dir}/${file}"
    if [[ "${1:-}" == "--check" ]]; then
      if ! cmp -s "${source}" "${target}"; then
        echo "Out of sync: ${target#"${repo_root}/"}" >&2
        exit 1
      fi
    else
      mkdir -p "$(dirname "${target}")"
      cp "${source}" "${target}"
    fi
  done
done
