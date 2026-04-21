---
effort: high
---

# /simplify-code — Simplify Existing Code

Target from $ARGUMENTS (file, function, or module) or ask. Read target code plus `CLAUDE.md` and `~/.claude/CLAUDE.md`.

Do NOT add features, fix bugs, or change behavior. Scope: simplification only.

---

Analyze for:
- **Dead code**: unused variables, unreachable branches, commented-out blocks
- **Redundant logic**: duplicated conditions, re-computed values, unnecessary wrappers
- **Premature abstractions**: interfaces/classes with one implementation, helpers used once
- **Over-engineering**: patterns that don't earn their complexity at current scale

For each finding, state:
- What it is and where (`file:line`)
- Why it can be removed or simplified
- The simpler form

Present all findings before editing. Ask: "Apply all / pick / skip?"

---

Apply approved changes. Run targeted tests to confirm behavior is unchanged. If any test fails, revert that change and report.

Print: what was simplified, lines removed, test status.
