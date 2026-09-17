# Socra agent plugins

Provider-specific plugins that give coding agents Socra session context and access to Cortex through MCP.

The repository is public. Install Cortex from `socra/agent-plugins` using the supported provider path below.

## Install Cortex

### Codex

```sh
codex plugin marketplace add socra/agent-plugins --ref main
codex plugin add cortex@socra
```

Plugin path: `providers/codex/cortex`

Codex receives Cortex guidance through the `socra-cortex` skill, displayed as Socra Cortex; this package has no SessionStart hook. Start a new task after updating to load the current skill.

### Grok Build

```sh
socra cortex setup
```

Setup detects `grok`, installs the native plugin, and configures its public OAuth client. Restart Grok, open `/mcps`, select Cortex, and press `i` to sign in. Confirm connectivity with `grok mcp doctor cortex` and ask Grok to use Cortex to list the Modules you can access.

For a manual installation:

```sh
grok plugin install 'socra/agent-plugins@main#providers/grok/cortex' --trust
```

Grok 1.0.30 loses plugin OAuth settings during reauthentication. Until that is fixed, the following entry is also needed in `~/.grok/config.toml` (setup handles this without replacing unrelated settings). If an entry already exists, reconcile it instead of adding a duplicate:

```toml
[mcp_servers.cortex]
type = "http"
url = "https://cortex.socra.cloud/mcp"
[mcp_servers.cortex.oauth]
clientId = "client_01m2gvz6jte3fh8qvs4jk0342s"
callbackPort = 49174
```

This public native OAuth client belongs to the `agent-plugins` project. Its registered redirect URI is `http://127.0.0.1:49174/callback`; no client secret is shipped. Grok stores the resulting tokens itself.

Plugin path: `providers/grok/cortex`. The plugin uses the shared `socra-cortex` skill and has no SessionStart hook. The native marketplace index is `.grok-plugin/marketplace.json`. Update with `socra cortex update` or `grok plugin update cortex`.

Grok can also import Claude plugins; use this native installation to select the Grok OAuth client and skill. See [Grok MCP documentation](https://docs.x.ai/build/features/mcp-servers) and [skills and plugins](https://docs.x.ai/build/features/skills-plugins-marketplaces).

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

The canonical Cortex skill lives at `shared/cortex/skills/socra-cortex/SKILL.md`. Its frontmatter description makes the skill discoverable; its body supplies the workflow when loaded. Codex and Grok package generated copies under their respective `providers/<provider>/cortex/skills/socra-cortex/` directories.

```sh
./scripts/sync-cortex-skills.sh
./scripts/sync-cortex-skills.sh --check
```

Keep the description as a single JSON-quoted YAML string, at most 1024 characters. The script validates that limit and checks for missing or stale provider copies. Add providers to its target list only after validating their skill support. Bump affected plugin versions when changing the skill. CI checks both skill and session-start synchronization.
