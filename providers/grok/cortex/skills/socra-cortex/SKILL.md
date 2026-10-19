---
name: socra-cortex
description: "Cortex helps people and teams stop repeating themselves to their AI. It keeps their preferences, requirements, decisions, and reasons in a single source of truth that agents can retrieve across conversations and tools.\n\nModules hold that knowledge, Dependencies connect prerequisite Modules, Flash loads a Module and its Dependencies, and Issues distill work that needs coordination into human-readable tasks.\n\nBefore executing a task, Flash its narrowest relevant Module(s). Flash known targets directly; otherwise prefer Search. Use Map only when Search leaves subjects or relationships unclear. Reuse a successful Flash while the required knowledge remains available in context. Retrieve missing knowledge again when needed.\n\nWhen conversation or work reveals preferences, requirements, decisions, or other specific knowledge, update the relevant Modules or create missing ones. Preserve the knowledge and its reasons and keep Dependencies consistent. Briefly name the affected Modules and explain what changed and why."
---

# Socra Cortex

## Overview

Cortex turns your team's specific knowledge and work into reusable infrastructure for agents:

- Modules contain owner-governed knowledge about how something should work and why.
- Dependencies compose Modules into a knowledge graph.
- Flash loads a named Module and its complete dependency closure into your context before you act.
- Issues distill work that needs coordination into human-readable tasks.
- Inbox is the pull-based work authorization surface: released Issues you are responsible for now.

Use Cortex when a task depends on team-specific knowledge or decisions, including architecture, constraints, priorities, or work history.

Inbox provides pull-based work authorization: assignment authorizes bounded work and Dependencies release it when prerequisites finish, so an agent asked to pull work can take a ready, assigned Issue without asking for the same authorization again. Unassigned Issues in Modules you own are yours to triage; work stays within the Issue’s scope, access permissions, and explicit approval requirements.

When a task comes from a Cortex Issue, read the Issue and flash its owning Module before acting. For other tasks, flash the narrowest relevant Module(s) directly. If you do not know which Module(s) are relevant, prefer context_search. Use context_map only when Search leaves subjects or relationships unclear.

When creating an Issue, attach it to the narrowest Module that fully governs the work so its Flash provides the most specific knowledge needed to do it.

Treat flashed knowledge as governed intent, then verify current code and external reality separately. When work reveals durable knowledge that could improve future decisions, compare it with existing Modules and update its narrowest owner, preserving the knowledge and its reasons. Create a Module only when no existing subject owns the knowledge. Follow the user's approval policy when one is configured; explicit approval of an exact change remains valid and does not need to be requested again.

## MCP

Use the connected Cortex MCP for knowledge retrieval and work coordination when its tools are available. It works directly through the host's authenticated connection.

Discover Cortex tools through the host's tool search or available-tool list. Hosts may prefix tool names; match the operation and read its current input schema instead of assuming a namespace or argument shape. Load only the tools needed for the current task.

- **Find and load knowledge:** Call `context_flash` directly for each known target Module. Otherwise prefer `context_search` with a relevant keyword, then Flash the narrowest relevant Module(s). Use `context_map` only when Search leaves subjects or relationships unclear. Search results and map summaries do not replace the full Flash. Reuse a successful Flash while the required knowledge remains available in context. Retrieve missing knowledge again when needed. Refresh outdated knowledge before relying on it. Before editing, use `context_get` only when the Module's content or direct Dependencies are missing or outdated in your context.
- **Coordinate work:** Use `issue_get` for a supplied Issue ID, `issue_list` to find related work, or `issue_inbox` when asked what to pick up next. Read `comment_list` for authored progress and `issue_event_list` for state changes when that history matters. Use `issue_create`, `issue_update`, and `comment_create` for authorized work tracking. Record the outcome and verification before marking work done.
- **Maintain knowledge:** Use `context_update` for an existing Module or `context_create` for a new subject within the user's instructions and access permissions. If the user requires proposals first, present the exact change and wait for approval before saving. Check the schema's replacement semantics and preserve unrelated content and Dependencies. Briefly name the affected Modules and explain what changed and why.

Read tool results for errors before treating an operation as successful. If a write has an uncertain outcome, read the affected record before retrying to avoid duplicates. If authentication or access is denied, report the limitation and continue independent work. If no Cortex connection is available, explain that the host's Cortex connection needs setup.
