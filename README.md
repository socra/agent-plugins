# Socra agent plugins

Cortex plugins teach your coding agent to preserve useful knowledge as you work, retrieve it for later tasks, and keep it current. You can start with an empty Account; you do not need to write Modules yourself.

Tell your agent whether it should save knowledge as you work or recommend changes and wait for your approval. The agent prepares the knowledge in either case. Your Account permissions and host's tool confirmations still apply.

The repository is public. Install Cortex from `socra/agent-plugins` using the supported provider path below, then [finish setup](#finish-setup).

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

## Finish setup

Ask your agent to follow the [coding-agent setup guide](https://workspace.socra.com/docs/cortex/integrations/coding-agents) to finish Account authorization and check the connection. Complete any sign-in or consent that needs you. For Grok Build, use the linked [Grok guide](https://workspace.socra.com/docs/cortex/integrations/grok#connect-grok-build).

Start a new session and use the guide's verification prompt. It checks a real Cortex tool call separately from whether the session received persistent Cortex guidance. An empty Module list is valid; there is no need to create a Module to test the connection.

Then continue your normal work. The agent can preserve useful decisions and corrections as they arise, following your review preference and the access you have given it.

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
