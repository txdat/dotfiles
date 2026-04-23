# Workflow: /make-plan — Plan Creation & Approval

Plans directory: `docs/plans/`. Warn if plan exists. Suggest `/explore` if area unfamiliar.

Filename: `docs/plans/<basename $PWD>_<yyyy-mm-dd>_<type>_<slug>.md` — slug max 5 words. Type: `feature`, `fix`, `refactor`.
Read `GEMINI.md`. Do NOT write code.

## Phase 1 — Draft
Ask clarifying questions (scope, boundaries, constraints, edge cases, done). Max 3 rounds.

Structure:
```
# Task: <name>
Status: planning
Type: <type>
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

### Test Steps (written before any implementation)
- [ ] Test 1: <what is tested> — verifies <invariant>

### Implementation Steps (implement to make tests pass)
- [ ] Step 1: Implement <what> — makes Test 1 pass

## Out of Scope (explicit)
- <item>: <why excluded>
```
Rules: Verifiable unit per step. Dependency-ordered. 5–10 steps total. Test Steps before Implementation Steps. Propose split if >10. Merge redundant steps. Every Implementation Step must reference a Test Step.

**TDD gate**: Validate `### Test Steps` non-empty & references exist before saving. Add missing, re-confirm.

Save draft. Show brief (Task, Type, Requirement, Step/Risk counts). Ask "Apply these changes?". Apply approved edits in place. Ask "Create a GitHub issue?". If yes: `gh issue create`, update `Issue:` field.

## Phase 2 — Review & Approve
Review saved plan for clarity, explicit scope, considered alternatives, actionable mitigations, verifiable steps.
Flag ambiguities. Unresolvable → ask (1 round max).
**TDD compliance (blocking)**: Validate new failing test (feature/fix) or passing coverage test (refactor). Propose missing.

Show brief: Verdict (READY | NEEDS CHANGES), blocking count, suggestion count, `<plan path>`.
Ask "Apply these changes?". Apply fixes. Set `Status: approved`. Print "Plan approved at `<path>`".
