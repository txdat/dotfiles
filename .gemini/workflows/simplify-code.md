# Workflow: /simplify-code — Simplify Existing Code

Target from input or ask. Read target + `GEMINI.md`. Do NOT add features, fix bugs, or change behavior. Simplification only.

## Parallel Analysis
If single file → analyze directly.

Otherwise, write shared context to `/tmp/gemini-ctx-$$.md`:
```
Standards: <key points from GEMINI.md>
Scope: simplification only — no features, no bug fixes, no behavior changes
```
Spawn parallel `generalist` tasks — one per file. Prompt: "Read /tmp/gemini-ctx-$$.md first. Analyze <file>. Find: dead code (unused vars, unreachable branches, commented code) · redundant logic (duplicate conditions, re-computed values, unnecessary wrappers) · premature abstractions (one-impl interfaces, single-use helpers) · over-engineering (patterns that don't earn their complexity). Per finding: file:line, why it simplifies, simpler form."

## Apply
Aggregate findings. Present before editing. Ask: "Apply all / pick / skip?".
Apply approved changes. Run targeted tests — if any fail, revert that change and report.
Print: what was simplified, lines removed, test status.
