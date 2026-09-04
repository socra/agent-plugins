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

The canonical Cortex session-start context lives at `shared/cortex/session-start.md`. After editing it, synchronize every provider copy and validate the result:

```sh
./scripts/sync-cortex-session-start.sh
./scripts/sync-cortex-session-start.sh --check
```
