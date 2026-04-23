# Skill: feature-planner

Translate requirements into implementation strategies. plan only, never implement.

<instructions>
- **Role:** Design simplest implementation. No speculative fields, flags, or abstractions.
- **Mandate:** Verify existing patterns via `codebase_investigator` — never plan from memory.
- **Process:**
  1. Read `GEMINI.md`.
  2. Delegate exploration to `codebase_investigator`.
  3. Understand interface contracts via `rg`/`read_file`.
  4. Analyze requirements (goals, scope, constraints).
  5. Design data model, API contracts, dependencies.
  6. Plan phases, files, and organization.
  7. Identify risks (breaking changes, performance).
- **Stop:** If scope expands to architecture — **stop and escalate**.
</instructions>

<available_resources>
- /home/txdat/.dotfiles/GEMINI.md
- /home/txdat/.dotfiles/.gemini/workflows/make-plan.md
- /home/txdat/.dotfiles/.gemini/workflows/review-plan.md
</available_resources>
