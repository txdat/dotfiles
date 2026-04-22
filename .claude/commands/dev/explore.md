---
model: haiku
---

# /explore — Codebase Exploration

Target from $ARGUMENTS (feature, module, file, or question) or ask. Read `CLAUDE.md` and `~/.claude/CLAUDE.md`.

Goal: structured findings summary to inform planning or debugging. Do NOT modify any files.

## Area Decomposition

Identify distinct codebase areas the target spans (e.g. auth layer, API handlers, DB models).

If single area → explore directly without spawning.

Otherwise, write shared context to `/tmp/claude-ctx-$$.md`:
```
Target: <feature/module/question>
Stack: <detected stack>
Standards: <key points from CLAUDE.md>
```

Spawn parallel `code-explorer` subagents — one per area. Each prompt: "Read /tmp/claude-ctx-$$.md first. Explore area: <name>. Use Grep/Glob to locate entry points, then LSP (`definition`, `references`, `hover`, `implementation`) to navigate. Report: entry points (file:line), key files, data flow, patterns, gotchas, open questions."

## Output

```
## Exploration: <target>

### Entry Points
- `file:line` — <description>

### Key Files
- `file` — <what it owns>

### Data Flow
<input → transform → output>

### Patterns in This Area
- <pattern>: <where it's used>

### Gotchas
- <non-obvious constraint or known issue>

### Open Questions
- <anything unclear before planning>
```

Print: "Exploration complete. Run /dev:make-plan to begin planning."
