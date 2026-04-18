# /make-plan — Requirement Analysis & Plan Creation

## Purpose
Transform a raw requirement into a clear, verified, actionable plan before any code is written.
This command produces the single source of truth that /execute-plan will follow.

---

## Step 1: Ingest Requirement

Read the requirement from $ARGUMENTS.

Resolve plans directory: read `plansDirectory` from project `CLAUDE.md`. If not set, default to `plans/`. Use this as `<plansDir>` throughout.

Determine the plan filename:
- **Project name**: current directory name (`basename $PWD`)
- **Date**: today's date in `yyyy-mm-dd` format
- **Feature name**: derive a short slug from $ARGUMENTS — lowercase, words joined with hyphens, max 4 words (e.g., "add user auth flow" → `add-user-auth-flow`)
- **Filename**: `<plansDir>/<project-name>_<date>_<feature-name>.md`

Also check if `<plansDir>` contains any plan file with status `approved` or `in-progress` — if it does, list them and ask:
"A task is already in progress. Continue one of these, or start a new one?"

Read project `CLAUDE.md` and `~/.claude/CLAUDE.md` for context before proceeding.

---

## Step 2: Clarify Through Questioning

Before writing any plan, identify ambiguities and ask targeted questions.
Group questions by concern — do not ask one at a time in a back-and-forth loop.
Ask all blocking questions in a single message.

Question checklist:
- Scope: What is explicitly in scope? What is out of scope?
- Boundaries: Which modules/services/APIs are affected?
- Constraints: Performance, consistency, backward-compatibility requirements?
- Edge cases: What are the failure modes? What happens at the boundaries?
- Definition of done: How do we know this is complete and correct?

Wait for answers before proceeding.
If any answer reveals new ambiguity, ask follow-up rounds — two follow-up rounds maximum.

---

## Step 3: Write the Plan

Produce the plan in this exact structure:

```
# Task: <name>
Status: planning

## Requirement
<One paragraph. What problem is being solved and why.>

## Scope
### In scope
- ...
### Out of scope
- ...

## Design Decisions
| Decision | Options Considered | Chosen | Reason |
|---|---|---|---|
| ... | A vs B | A | ... |

## Risk Flags
- [ ] <risk>: <mitigation>

## Implementation Checklist

### Test Steps (written before any implementation)
- [ ] Test 1: Write failing test for <what> — verifies <invariant>
- [ ] Test 2: Write failing test for <what> — verifies <invariant>
- [ ] ...

### Implementation Steps (implement to make tests pass)
- [ ] Step 1: Implement <what> — makes Test 1 pass
- [ ] Step 2: Implement <what> — makes Test 2 pass
- [ ] ...

## Out of Scope (explicit)
- ...
```

Rules for the checklist:
- Each step = one logical unit of work, completable in isolation
- Steps must be ordered by dependency (nothing blocks step N unless step N-1 is listed)
- No step should be "implement X" without specifying the observable outcome
- Aim for 5–10 steps; if more, consider splitting into sub-tasks

---

## Step 4: Review and Simplify

After writing the plan, self-review it:
1. Can any two steps be merged without losing clarity? Merge them.
2. Is any step ambiguous about its done state? Rewrite it.
3. Are there steps that are pure boilerplate with no decisions? Remove or inline them.
4. Does every Implementation Step have a corresponding Test Step written before it? If not, add the missing test steps.
5. Are all Test Steps listed before all Implementation Steps? If not, reorder them.

Then present the simplified plan to the user.

---

## Step 5: Confirm

Ask: "Does this plan look correct? Any changes before I save it?"

Apply any user edits.

**TDD gate** — before saving as `approved`, verify:
- The checklist has a non-empty `### Test Steps` section
- Every Implementation Step references a Test Step
If either check fails, add the missing test steps and ask the user to confirm again.

Update status to: `approved`
Write final plan to the filename determined in Step 1.
Print: "Plan saved to <plansDir>/<filename>. Run /execute-plan <filename> to begin implementation."

Do NOT write any code or suggest any implementation yet.
