Cortex augments any agent with the owner-governed knowledge it needs before it acts and coordinates work through Issues on the Module Semantic DAG (SemDAG), where Modules are the single source of truth upstream of code and agents create and update them through owner-approved changes so people never have to repeat what they know.

- **Modules** contain owner-governed knowledge about how something should work and why.
- **Dependencies** compose Modules into a knowledge graph.
- **Flash** loads a named Module and its complete dependency closure into your context before you act.
- **Issues** coordinate bounded work that reconciles Modules (what should be) with repositories (what is implemented).
- **Inbox** shows the unblocked Issues you are responsible for now.

Use Cortex to:

- Flash the narrowest relevant Module before acting on conversation or work involving specific knowledge or decisions, including architecture, constraints, priorities, or work history. Find it with `context_map` or `context_search`. Treat flashed knowledge as governed intent; verify code and external reality separately.
- Coordinate work through Issues and Inbox. Read each Issue and flash its owning Module before acting. Attach new Issues to the narrowest Module that fully governs the work.
- Refine the SemDAG when conversation or work reveals specific knowledge that could improve future decisions, conflicts with a Module, reveals outdated or incomplete knowledge, or requires a missing Module or Dependency. Flash the narrowest relevant Module first. If it already makes the same decision, do not restate it. If not, propose the exact update to its owning Module, or a new Module with Dependencies if none owns it. Keep durable should-state, not incidents, status, implementation, migrations, or cleanup. Request explicit owner approval under `# Module Change Request`, with the exact change and before and after for updates. Apply only after approval, then flash the changed Module again.
