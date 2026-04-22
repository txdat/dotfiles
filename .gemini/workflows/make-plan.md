# Workflow: /make-plan — Requirement Analysis & Plan Creation

Plans directory: `docs/plans/`. Warn and ask if an `approved` or `in-progress` plan already exists. If the codebase area is unfamiliar, use `codebase_investigator` first.

Filename: `docs/plans/<basename $PWD>_<yyyy-mm-dd>_<type>_<slug>.md` — slug from input, max 5 words, hyphenated.

**Rules:**
- Read project `GEMINI.md` before proceeding.
- Do NOT write any code.
- Ask clarifying questions grouped by concern (scope, boundaries, constraints, edge cases, definition of done). Up to 3 rounds maximum.

**Structure:**
```markdown
# Task: <name>
Status: planning
Type: feature | fix | refactor
Issue: #N

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
- [ ] Test 1: <what is tested> — verifies <invariant>

### Implementation Steps (implement to make tests pass)
- [ ] Step 1: Implement <what> — makes Test 1 pass

## Out of Scope (explicit)
- <item>: <why excluded>
```

**Checklist Rules:**
- Each step = one verifiable unit of work.
- Dependency-ordered (step N never requires step N+1).
- Target 5–10 total steps.
- Test Steps before Implementation Steps.
- Every Implementation Step must reference a Test Step.

**TDD Gate:**
Do not set status `approved` unless `### Test Steps` is non-empty and every Implementation Step references a Test Step. Add missing test steps and re-confirm if needed.

**Draft Brief**: Show a brief of the plan before saving (Task name, Type, Requirement 1-line summary, counts for steps/risks). Ask "Apply these changes?". Apply approved edits in place. Ask "Create a GitHub issue for this plan?". If yes, run `gh issue create` and update `Issue:` field.
