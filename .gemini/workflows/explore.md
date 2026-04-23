# Workflow: /explore — Codebase Exploration

Target from input or ask. Read `GEMINI.md`. Do NOT modify files.
Goal: structured findings summary to inform planning/debugging.

## Area Decomposition
Identify codebase areas (e.g., auth, API, DB).
If single area → explore directly using `codebase_investigator`.

Otherwise, write context to `/tmp/gemini-ctx-$$.md`:
```
Target: <feature/module/question>
Stack: <detected stack>
Standards: <key points from GEMINI.md>
```
Spawn parallel `generalist` tasks (or concurrent `codebase_investigator` calls) — one per area.
Prompt: "Read /tmp/gemini-ctx-$$.md first. Explore area: <name>. Use `grep_search` and `glob` for entry points, then navigate. Report: entry points (file:line), key files, data flow, patterns, gotchas, open questions."

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
- <pattern>: <where used>

### Gotchas
- <non-obvious constraint/known issue>

### Open Questions
- <unclear before planning>
```
Print: "Exploration complete."
