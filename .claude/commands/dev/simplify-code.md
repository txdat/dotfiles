---
effort: high
---

# /simplify-code — Simplify Existing Code

Target from $ARGUMENTS (file, function, or module) or ask. Read target code plus `CLAUDE.md` and `~/.claude/CLAUDE.md`.

Do NOT add features, fix bugs, or change behavior. Scope: simplification only.

## Parallel Analysis

If single file → analyze directly without spawning.

Otherwise, write shared context to `/tmp/claude-ctx-$$.md`:
```
Standards: <key points from CLAUDE.md>
Scope: simplification only — no features, no bug fixes, no behavior changes
```

Spawn parallel `code-explorer` subagents — one per file. Each prompt: "Read /tmp/claude-ctx-$$.md first. Analyze <file>. Find: dead code (unused vars, unreachable branches, commented-out blocks) · redundant logic (duplicate conditions, re-computed values, unnecessary wrappers) · premature abstractions (one-impl interfaces, single-use helpers) · over-engineering (patterns that don't earn their complexity). Per finding: file:line, why it simplifies, simpler form."

## Apply

Aggregate findings. Present before editing. Ask: "Apply all / pick / skip?"

Apply approved changes. Run targeted tests — if any fail, revert that change and report.

Print: what was simplified, lines removed, test status.
