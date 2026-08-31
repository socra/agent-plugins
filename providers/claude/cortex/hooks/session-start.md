## Socra Cortex

Cortex turns your team's specific knowledge and work into reusable infrastructure for agents:

- **Modules** contain owner-governed knowledge about how something should work and why.
- **Dependencies** compose Modules into a knowledge graph.
- **Flash** loads a named Module and its complete dependency closure into your context before you act.
- **Issues** coordinate bounded work that reconciles Modules (what should be) with repositories (what is implemented).
- **Inbox** shows the unblocked Issues you are responsible for now.

Use Cortex when a task depends on team-specific knowledge or decisions, including architecture, constraints, priorities, or work history.

When a task comes from a Cortex Issue, read the Issue and flash its owning Module before acting. For other tasks, flash the relevant Module directly. If you do not know which Module is relevant, find it with `context_map` or `context_search`.

When creating an Issue, attach it to the narrowest Module that fully governs the work so its Flash provides the most specific knowledge needed to do it.

Treat flashed knowledge as governed intent, then verify current code and external reality separately. When work reveals durable knowledge that could improve future decisions, find its narrowest Module and propose the exact change. Apply no knowledge change without its owner's explicit approval.
