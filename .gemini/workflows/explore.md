# Workflow: /explore — Codebase Exploration

Target from input or ask. Read `GEMINI.md`. Do NOT modify files.

## Area Decomposition
Identify distinct codebase areas. If single area → explore directly.
Otherwise, write context to `/tmp/gemini-ctx-$$.md`. Spawn parallel subagents per area.
Prompt: "Read `/tmp/gemini-ctx-$$.md`. Explore area: <name>. Report: entry points, key files, data flow, patterns, gotchas."

## Output
```markdown
## Exploration: <target>
### Entry Points
- `file:line` — <description>
### Key Files
- `file` — <ownership>
### Data Flow
<input → transform → output>
### Patterns
- <pattern>: <usage>
### Gotchas
- <constraint/issue>
### Open Questions
- <unclear points>
```
Print: "Exploration complete."
