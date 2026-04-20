---
effort: high
---

# /make-plan — Requirement Analysis & Plan Creation

Resolve `plansDirectory` from project `CLAUDE.md` (default: `plans/`). Warn and ask if an `approved` or `in-progress` plan already exists.

Filename: `<plansDir>/<basename $PWD>_<yyyy-mm-dd>_<slug>.md` — slug from $ARGUMENTS, max 4 words, hyphenated.

Read project `CLAUDE.md` and `~/.claude/CLAUDE.md` before proceeding. Do NOT write any code.

---

Ask clarifying questions grouped by concern (scope, boundaries, constraints, edge cases, definition of done). Up to 3 rounds maximum.

---

Write the plan in this exact structure:

```
# Task: <name>
Status: planning

## Requirement
<one paragraph — what problem is being solved and why>

## Scope
### In scope
### Out of scope

## Design Decisions
| Decision | Options Considered | Chosen | Reason |

## Risk Flags
- [ ] <risk>: <mitigation>

## Implementation Checklist

### Test Steps (written before any implementation)
- [ ] Test 1: Write failing test for <what> — verifies <invariant>

### Implementation Steps (implement to make tests pass)
- [ ] Step 1: Implement <what> — makes Test 1 pass

## Out of Scope (explicit)
```

Checklist rules: each step = one verifiable unit of work; steps ordered by dependency (nothing in step N requires step N+1); 5–10 total steps; Test Steps before Implementation Steps.

Self-review: merge redundant steps, ensure every Implementation Step has a corresponding Test Step.

Present to user. Apply edits.

**TDD gate**: do not save as `approved` unless `### Test Steps` is non-empty and every Implementation Step references a Test Step. Add missing test steps and re-confirm if needed.

Save to filename. Print: "Plan saved to `<path>`. Run /execute-plan to begin."
