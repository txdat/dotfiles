# Workflow: /explore — Codebase Exploration

Target from input or ask. Read `GEMINI.md`. Do NOT modify files.
Goal: structured findings summary to inform planning or debugging.

## Area Decomposition
Identify distinct codebase areas the target spans (e.g., auth layer, API handlers, DB models).
If single area → explore directly using `codebase_investigator`.

Otherwise, write shared context to `/tmp/gemini-ctx-$$.md`:
```
Target: <feature/module/question>
Stack: <detected stack>
Standards: <key points from GEMINI.md>
```
Spawn parallel `generalist` tasks (or concurrent `codebase_investigator` calls) — one per area.
Prompt: "Read /tmp/gemini-ctx-$$.md first. Explore area: <name>. Use `grep_search` and `glob` to locate entry points, then navigate. Report: entry points (file:line), key files, data flow, patterns, gotchas, open questions."

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
