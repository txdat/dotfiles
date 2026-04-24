---
effort: high
---

# /make-plan — Plan Creation & Approval

If `skip approval` context — auto-approve all prompts (changes, issue creation).

Warn if `approved`/`in-progress` plan exists. Unfamiliar area → suggest `/dev:explore`.

Filename: `docs/plans/<basename>_<date>_<type>_<slug>.md`. Type: feature/fix/refactor.

Read `CLAUDE.md`. Do NOT write code.

## Phase 1 — Draft

Clarify: scope, boundaries, constraints, edge cases, done. Up to 3 rounds.

```
# Task: <name>
Status: planning
Type: <type>
Issue:

## Requirement
<problem and why>

## Scope
### In scope
### Out of scope

## Design Decisions
| Decision | Options | Chosen | Reason |

## Risk Flags
- [ ] <risk>: <mitigation>

## Implementation Checklist

### Test Steps
- [ ] Test 1: <tested> — verifies <invariant>

### Implementation Steps
- [ ] Step 1: <what> — makes Test 1 pass

## Out of Scope (explicit)
- <item>: <why>
```

Rules: 5–10 steps, dependency-ordered, Tests before Impl, every Impl refs a Test. >10 → propose split.

**TDD gate**: Test Steps non-empty, all Impl refs Test.

Save. Show: name, type, requirement, counts, path.

Ask: "Changes?" then "Create issue?" If yes: `gh issue create`. Update `Issue:` field.

## Phase 2 — Review

- Requirement: clear, measurable
- Scope: explicit
- Design: alternatives + reasoning
- Risks: actionable
- Steps: ordered, verifiable

Flag ambiguities. One round max.

**TDD (blocking)**: Feature/fix → failing tests. Refactor → coverage tests.

Show: Verdict, Blocking N, Suggestions N.

Ask: "Apply?" Set `approved`. Print path.
