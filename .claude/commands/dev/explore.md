---
model: haiku
effort: medium
---

# /explore — Codebase Exploration

Target from $ARGUMENTS (feature, module, file, or question) or ask. Read `CLAUDE.md` and `~/.claude/CLAUDE.md`.

Goal: produce a structured findings summary to inform planning or debugging. Do NOT modify any files.

---

Use LSP (`definition`, `references`, `hover`, `implementation`) as primary navigation. Fall back to Grep/Glob to locate entry points.

Explore:
- **Entry points**: where the feature/flow starts (handlers, commands, event listeners)
- **Key files**: core logic, models, services touched by the target area
- **Data flow**: how data moves through the system (input → transform → output)
- **Patterns**: naming conventions, error handling, testing approach in this area
- **Gotchas**: non-obvious constraints, TODOs, known issues, workarounds

---

Produce:

```
## Exploration: <target>

### Entry Points
- `file:line` — <description>

### Key Files
- `file` — <what it owns>

### Data Flow
<brief description>

### Patterns in This Area
- <pattern>: <where it's used>

### Gotchas
- <non-obvious constraint or known issue>

### Open Questions
- <anything unclear that needs clarification before planning>
```

Print: "Exploration complete. Run /dev:make-plan to begin planning."
