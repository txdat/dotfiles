---
effort: high
---

# /review-plan — Review and Improve an Existing Plan

Resolve `plansDirectory` from project `CLAUDE.md` (default: `plans/`). Find plan from $ARGUMENTS (full/partial name) or auto-discover by status `planning`/`approved`. If multiple, ask. If none, stop.

Read the plan plus project `CLAUDE.md` and `~/.claude/CLAUDE.md`.

---

Review across: requirement clarity, scope completeness, design decision justification (alternatives considered), risk coverage with actionable mitigations, step ordering and granularity (5–10 steps, each verifiable), test coverage per risk.

**Ambiguities**: undefined terms, missing constraints, edge cases not addressed, assumptions a developer would have to make.

**TDD compliance (blocking)**: checklist must have a non-empty `### Test Steps` section; all Test Steps listed before Implementation Steps; every Implementation Step references a Test Step. Missing TDD structure is always a `❌` blocking issue — propose the missing test steps.

If ambiguity cannot be resolved from the plan, ask clarifying questions grouped by concern. One follow-up round maximum.

---

Produce report:

```
## Plan Review: <filename>

### ✅ What's solid
### ❌ Issues (must fix before execution)
- Section — <issue> — <suggested fix>
### ⚠️ Suggestions (recommended, not blocking)
### Verdict: READY | NEEDS CHANGES
```

Ask: "Apply these changes?" Apply approved edits in place.

If status was `planning` and all blocking issues resolved → set `approved`.
Print: "Plan updated. Run /execute-plan to begin."

Do NOT write any code.
