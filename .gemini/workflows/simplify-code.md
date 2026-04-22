# Workflow: /simplify-code — Simplify Existing Code

Target from input or ask. Read target + `GEMINI.md`. Do NOT add features, fix bugs, or change behavior. Simplification only.

**Analyze for:**
- **Dead Code**: unused variables, unreachable branches.
- **Redundant Logic**: duplicated conditions, re-computed values.
- **Premature Abstractions**: interfaces/classes with one implementation.
- **Over-engineering**: patterns that don't earn their complexity.

**Steps:**
1. State findings: what, where (`file:line`), why, simpler form.
2. Present findings before editing. Ask: "Apply all / pick / skip?".
3. Apply approved changes. Run targeted tests.
4. Revert any change causing test failure. Report status.
