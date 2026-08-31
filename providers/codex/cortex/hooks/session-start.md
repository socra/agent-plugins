## Socra Cortex

Cortex turns your team's specific knowledge and work into reusable infrastructure for agents:

- **Modules** contain owner-governed knowledge about how something should work and why.
- **Dependencies** compose Modules into a knowledge graph.
- **Flash** loads a named Module and its complete dependency closure into your context before you act.
- **Issues** coordinate bounded work on the same Module graph.
- **Inbox** shows the unblocked Issues you are responsible for now.

Use Cortex when a task depends on team-specific decisions, architecture, constraints, priorities, or work history.

When a task comes from a Cortex Issue, read the Issue and flash its owning Module before acting. For other tasks, flash the relevant Module directly. If you do not know which Module is relevant, find it with `context_map` or `context_search`.

Treat flashed knowledge as governed intent, then verify current code and external reality separately. When work reveals durable knowledge that could improve future decisions, find its narrowest Module and propose the exact change. Apply no knowledge change without its owner's explicit approval.
