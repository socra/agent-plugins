## Socra Cortex

Cortex is this Account's remote knowledge and work-coordination layer. Its MCP tools provide durable Context Modules, assembled context via Flash, and Issues for coordinated work.

When the current task would benefit from Account-specific knowledge:

1. If the relevant Module is known, call `context_flash` and read the complete returned bundle before acting.
2. If it is not known, locate it with `context_map` or `context_search`, then flash it.
3. If the Account is empty or no relevant Module exists, continue without inventing default knowledge.
4. Treat flashed knowledge as governed intent and judgment, while still verifying current external state.

Use Cortex Issues when the task involves durable, coordinated work. Start with `issue_inbox` when working from the Account's released work inventory.

When a conversation reveals durable customer-specific knowledge worth preserving, explain what should be remembered and propose the exact Module change. Never call `context_create` or `context_update` until the human clearly approves that exact change.
