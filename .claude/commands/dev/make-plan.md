---
effort: high
---

# /make-plan — Requirement Analysis & Plan Creation

Plans directory: `docs/plans/`. Warn and ask if an `approved` or `in-progress` plan already exists. If the codebase area is unfamiliar, suggest running `/dev:explore` first.

Filename: `docs/plans/<basename $PWD>_<yyyy-mm-dd>_<type>_<slug>.md` — slug from $ARGUMENTS, max 5 words, hyphenated.

Read project `CLAUDE.md` and `~/.claude/CLAUDE.md` before proceeding. Do NOT write any code.

Ask clarifying questions grouped by concern (scope, boundaries, constraints, edge cases, definition of done). Up to 3 rounds maximum.

Write the plan in this exact structure:

```
# Task: <name>
Status: planning
Type: feature | fix | refactor

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
For feature/fix: failing tests that verify new behavior.
For refactor: coverage/characterization tests that pass before AND after.
- [ ] Test 1: <write failing test for <what> | verify coverage for <area>> — verifies <invariant>

### Implementation Steps (implement to make tests pass)
- [ ] Step 1: Implement <what> — makes Test 1 pass

## Out of Scope (explicit)
Items considered during planning but deliberately excluded — future sessions must not re-litigate these.
- <item>: <why excluded>
```

Checklist rules: each step = one verifiable unit of work; dependency-ordered (step N never requires step N+1); target 5–10 total steps; Test Steps before Implementation Steps. If steps exceed 10, stop — propose a split before continuing.

Merge redundant steps. Ensure every Implementation Step has a corresponding Test Step.

Present to user. Ask: "Apply these changes?" Apply approved edits in place.

**TDD gate**: do not set status `approved` unless `### Test Steps` is non-empty and every Implementation Step references a Test Step. Add missing test steps and re-confirm if needed.

Save to filename. Print: "Plan saved to `<path>`. Run /dev:execute-plan to begin."
