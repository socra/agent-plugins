---
name: socra-cortex
description: "Cortex helps people and teams stop repeating themselves to their AI. It keeps their preferences, requirements, decisions, and reasons in a single source of truth that agents can retrieve across conversations and tools.\n\nModules hold that knowledge, Dependencies connect prerequisite Modules, Flash loads a Module and its Dependencies, and Issues track work that needs coordination.\n\nBefore executing a task, find and Flash its narrowest relevant Module, using Search or Map if needed.\n\nWhen conversation or work reveals preferences, requirements, decisions, or other specific knowledge, update the relevant Modules or create missing ones. Preserve the knowledge and its reasons, keep Dependencies consistent, and Flash to verify. Briefly tell the user what changed and why."
---

# Socra Cortex

## Overview

Cortex turns your team's specific knowledge and work into reusable infrastructure for agents:

- Modules contain owner-governed knowledge about how something should work and why.
- Dependencies compose Modules into a knowledge graph.
- Flash loads a named Module and its complete dependency closure into your context before you act.
- Issues coordinate bounded work that reconciles Modules (what should be) with repositories (what is implemented).
- Inbox is the pull-based work authorization surface: released Issues you are responsible for now.

Use Cortex when a task depends on team-specific knowledge or decisions, including architecture, constraints, priorities, or work history.

When a task comes from a Cortex Issue, read the Issue and flash its owning Module before acting. For other tasks, flash the relevant Module directly. If you do not know which Module is relevant, find it with context_map or context_search.

When creating an Issue, attach it to the narrowest Module that fully governs the work so its Flash provides the most specific knowledge needed to do it.

Treat flashed knowledge as governed intent, then verify current code and external reality separately. When work reveals durable new knowledge that could improve future decisions, find its narrowest Module and propose the exact change/update. Apply no knowledge change without its owner's explicit approval.

## Pull-based work authorization

When asked to work from Cortex or operating under an existing mandate to pull work, use Inbox to choose what to do next. Assignment supplies the demand; Dependencies control when it is released. This lets owners authorize bounded work ahead of time without having to repeat the instruction when its prerequisites finish. Pulling an assigned, ready Issue does not require asking for that same authorization again.

Inbox contains unclosed Issues whose Dependencies are all terminal (`done` or `canceled`) and which are either assigned to the authenticated operator or unassigned in a Module they own. Assigned work is theirs to execute; unassigned work in an owned Module is theirs to triage, take on, or assign. Another operator's work is not theirs to claim merely because it is visible elsewhere.

Read the Issue and Flash its owning Module before starting. An `open` Issue is ready to claim; an `in_progress` Issue is already underway, so resume it only when it is your existing work. Record assignment and `in_progress` status when taking ownership, then work within the Issue's scope and acceptance criteria. Inbox routing does not expand access permissions, authorize unrelated changes, or override explicit approval requirements such as publishing Module changes.

An empty Inbox means no work is currently released to this identity. Do not invent work or begin blocked Issues to fill it. Check Inbox in service of the user's current request or an established work loop; installing Cortex alone does not authorize an autonomous work loop.

## MCP

Use the connected Cortex MCP for knowledge retrieval and work coordination when its tools are available. It works directly through the host's authenticated connection.

Discover Cortex tools through the host's tool search or available-tool list. Hosts may prefix tool names; match the operation and read its current input schema instead of assuming a namespace or argument shape. Load only the tools needed for the current task.

- **Find and load knowledge:** Call `context_flash` directly when the Module is known. Otherwise use `context_search` for a relevant keyword or `context_map` to understand the graph, then Flash the narrowest relevant Module. Search results and map summaries do not replace the full Flash. Use `context_get` to inspect one Module's current content and direct Dependencies before proposing an edit.
- **Coordinate work:** Use `issue_get` for a supplied Issue ID, `issue_list` to find related work, or `issue_inbox` when asked what to pick up next. Read `comment_list` for authored progress and `issue_event_list` for state changes when that history matters. Use `issue_create`, `issue_update`, and `comment_create` for authorized work tracking. Record the outcome and verification before marking work done.
- **Maintain knowledge:** After the owner approves the exact change, use `context_update` for an existing Module or `context_create` for a new subject. Check the schema's replacement semantics, preserve unrelated content and Dependencies, and Flash the saved Module to verify the result.

Read tool results for errors before treating an operation as successful. If a write has an uncertain outcome, read the affected record before retrying to avoid duplicates. If authentication or access is denied, report the limitation and continue independent work. If no Cortex connection is available, explain that the host's Cortex connection needs setup.
