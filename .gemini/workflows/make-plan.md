# Workflow: /make-plan — Plan Creation & Approval

Plans dir: `docs/plans/`. read `GEMINI.md`. Do NOT write code.

## Phase 1 — Draft
1. **Clarify:** Group questions by concern (scope, boundaries, edge cases, done). Max 3 rounds.
2. **Structure:**
```markdown
# Task: <name>
Status: planning
Type: feature | fix | refactor
Issue:

## Requirement
<one paragraph — problem & why>

## Scope
### In scope
### Out of scope

## Design Decisions
| Decision | Options Considered | Chosen | Reason |

## Risk Flags
- [ ] <risk>: <mitigation>

## Implementation Checklist
### Test Steps (written before implementation)
- [ ] Test 1: <what is tested> — verifies <invariant>

### Implementation Steps (implement to make tests pass)
- [ ] Step 1: Implement <what> — makes Test 1 pass
```
3. **Rules:** Verifiable units. Dependency-ordered. 5–10 steps total. Propose split if >10. Merge redundant steps.
4. **TDD gate:** Validate `### Test Steps` non-empty and referenced.
5. **Brief:** Show brief (Task, Type, Step/Risk counts). Ask "Apply?". Apply edits. Ask "Create issue?".

## Phase 2 — Review & Approve
1. **Review:** clear requirement, explicit scope, considered alternatives, actionable mitigations, verifiable steps.
2. **Ambiguity:** Flag undefined terms/constraints. Max 1 round.
3. **TDD Check:** `feature/fix` = failing test; `refactor` = passing coverage test.
4. **Status:** Set `Status: approved`.
