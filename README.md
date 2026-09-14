# Socra agent plugins

Provider-specific plugins that give coding agents Socra session context and access to Cortex through MCP.

The repository is currently private. Authenticate GitHub access before installing from `socra/agent-plugins`.

## Install Cortex

### Codex

```sh
codex plugin marketplace add socra/agent-plugins --ref main
codex plugin add cortex@socra
```

Plugin path: `providers/codex/cortex`

Codex receives Cortex guidance through the `socra-cortex` skill, displayed as Socra Cortex; this package has no SessionStart hook. Start a new task after updating to load the current skill.

### Claude Code

```sh
claude plugin marketplace add socra/agent-plugins --scope user
claude plugin install cortex@socra
```

Plugin path: `providers/claude/cortex`

### Cursor

Until the Socra marketplace is connected in Cursor, clone this repository and link the provider directory for local installation:

```sh
gh repo clone socra/agent-plugins
mkdir -p ~/.cursor/plugins/local
ln -s "$(pwd)/agent-plugins/providers/cursor/cortex" ~/.cursor/plugins/local/cortex
```

Restart Cursor or run **Developer: Reload Window**, then confirm Cortex under **Customize**.

Plugin path: `providers/cursor/cortex`

### GitHub Copilot CLI

```sh
copilot plugin marketplace add socra/agent-plugins
copilot plugin install cortex@socra
```

Plugin path: `providers/copilot/cortex`

## Development

The canonical Cortex session-start context lives at `shared/cortex/session-start.md`. After editing it, synchronize the Claude, Cursor, and Copilot hook copies and validate the result:

```sh
./scripts/sync-cortex-session-start.sh
./scripts/sync-cortex-session-start.sh --check
```

When changing session-start guidance, bump each affected provider plugin version and its marketplace version (where present) so installed plugin caches receive the update.

The canonical Cortex skill lives at `shared/cortex/skills/socra-cortex/SKILL.md`. Its frontmatter description makes the skill discoverable; its body supplies the workflow when loaded. Codex packages a generated copy at `providers/codex/cortex/skills/socra-cortex/SKILL.md`.

```sh
./scripts/sync-cortex-skills.sh
./scripts/sync-cortex-skills.sh --check
```

Keep the description as a single JSON-quoted YAML string, at most 1024 characters. The script validates that limit and checks for missing or stale provider copies. Add providers to its target list only after validating their skill support. Bump affected plugin versions when changing the skill. CI checks both skill and session-start synchronization.
