---
effort: high
---

# /make-plan — Plan Creation & Approval

Plans directory: `docs/plans/`. Warn and ask if an `approved` or `in-progress` plan already exists. If the codebase area is unfamiliar, suggest running `/dev:explore` first.

Filename: `docs/plans/<basename $PWD>_<yyyy-mm-dd>_<type>_<slug>.md` — slug from $ARGUMENTS, max 5 words, hyphenated. Determine `<type>`: `feature` (new capability), `fix` (bug), `refactor` (structural change, no behavior change).

Read project `CLAUDE.md` and `~/.claude/CLAUDE.md` before proceeding. Do NOT write any code.

## Phase 1 — Draft

Ask clarifying questions grouped by concern (scope, boundaries, constraints, edge cases, definition of done). Up to 3 rounds maximum.

Write the plan in this exact structure:

```
# Task: <name>
Status: planning
Type: <type>
Issue:

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
- [ ] Test 1: <what is tested> — verifies <invariant>

### Implementation Steps (implement to make tests pass)
- [ ] Step 1: Implement <what> — makes Test 1 pass

## Out of Scope (explicit)
Items considered during planning but deliberately excluded — future sessions must not re-litigate these.
- <item>: <why excluded>
```

Checklist rules: each step = one verifiable unit of work; dependency-ordered (step N never requires step N+1); target 5–10 total steps; Test Steps before Implementation Steps. If steps exceed 10, stop — propose a split before continuing.

Merge redundant steps; every Implementation Step must reference a Test Step.

**TDD gate**: validate `### Test Steps` non-empty and every Implementation Step references a Test Step before saving. Add missing test steps if needed, re-confirm before saving.

Save draft. Show brief:
- Task name, Type
- Requirement: <1-line summary>
- Test Steps: N | Implementation Steps: N
- Risk Flags: N
- `<path>`

Ask: "Apply these changes?" Apply approved edits in place.

Ask: "Create a GitHub issue for this plan?" If yes:
```bash
gh issue create --title "<Task name>" --body "<Requirement paragraph>"
```
Update `Issue:` field with created issue number.

## Phase 2 — Review & Approve

Review the saved plan:
- **Requirement**: clear problem statement, measurable definition of done
- **Scope**: in/out explicit, no hidden assumptions
- **Design decisions**: alternatives considered, reasoning stated
- **Risks**: each has actionable mitigation
- **Steps**: dependency-ordered; each verifiable

Flag ambiguities: undefined terms, missing constraints, unaddressed edge cases. If unresolvable, ask — one round maximum.

**TDD compliance (blocking)** — validate content by type:
- *Feature/fix*: each Test Step describes a new failing test
- *Refactor*: each Test Step describes coverage/characterization tests that pass before and after

Show:
- Verdict: READY | NEEDS CHANGES
- ❌ Blocking: N (titles only)
- ⚠️ Suggestions: N (titles only)

Ask: "Apply these changes?" Apply approved fixes. Set `Status: approved`.

Print: "Plan approved at `<path>`."
