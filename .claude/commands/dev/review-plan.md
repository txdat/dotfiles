---
effort: high
---

# /review-plan — Review and Improve an Existing Plan

## Purpose
Review an existing plan for completeness, clarity, and correctness before execution begins.
Produces a structured list of issues and proposed improvements, then applies approved changes in place.

---

## Step 1: Resolve Plan File

Resolve plans directory: read `plansDirectory` from project `CLAUDE.md`. If not set, default to `plans/`. Use this as `<plansDir>` throughout.

Determine the target plan file from $ARGUMENTS:
- If $ARGUMENTS is a full or partial filename, resolve it against `<plansDir>` (same logic as `/execute-plan`)
- If $ARGUMENTS is empty:
  - List all `.md` files in `<plansDir>` with status `planning` or `approved`
  - If exactly one → use it automatically
  - If multiple → print the list and ask: "Which plan do you want to review?"
  - If none → STOP. Print: "No plan found in <plansDir>. Run /make-plan first."

Read the resolved plan file in full.
Read project `CLAUDE.md` and `~/.claude/CLAUDE.md` for context.

---

## Step 2: Review the Plan

Evaluate the plan across these dimensions:

### 2.1 Requirement
- Is it clear what problem is being solved and why?
- Is the requirement traceable to a user or system need — not just a technical task?

### 2.2 Scope
- Is "in scope" explicitly and unambiguously listed?
- Is "out of scope" explicitly stated — not left implicit?
- Are there obvious gaps between the requirement and what the scope covers?

### 2.3 Design Decisions
- Is each decision justified with reasoning?
- Are alternatives actually considered, or is there only one option listed?
- Are any significant decisions missing (e.g., data model, error handling strategy)?

### 2.4 Risk Flags
- Are the obvious failure modes captured?
- Is each mitigation actionable and specific — not vague ("add tests", "handle errors")?
- Are any risks missing given the scope and design decisions?

### 2.5 Implementation Checklist
- Are steps ordered by dependency? Does any step N depend on something not in step N-1?
- Is each step's done state observable and verifiable?
- Are there 5–10 steps? If fewer: too coarse. If more: consider splitting.
- Does any step silently include multiple logical units of work?

### 2.6 Test Strategy
- Does every risk flag have a corresponding test entry?
- Are test types (unit/integration/e2e) appropriate for each step's invariant?
- Are any steps in the checklist untested?

### 2.7 TDD Compliance (blocking)
- Does the checklist have a `### Test Steps` section with at least one entry?
- Are all Test Steps listed **before** all Implementation Steps?
- Does every Implementation Step reference a corresponding Test Step?
- If any of the above are missing: this is a blocking issue — propose the missing test steps, written in the same sequential format (`### Test Steps` first, then `### Implementation Steps`).

### 2.8 Ambiguities
- Are there undefined terms, missing constraints, or edge cases not addressed?
- Would a developer reading this plan need to make assumptions not captured here?

---

## Step 3: Ask Targeted Questions (if needed)

If any dimension in Step 2 reveals ambiguity that cannot be resolved from the plan alone:

Group all questions by concern — do not ask one at a time.
Ask all blocking questions in a single message.
Wait for answers before proceeding.
One follow-up round maximum if an answer reveals new ambiguity.

If the plan is clear enough to proceed without questions, skip to Step 4.

---

## Step 4: Propose Changes

Produce a review report in this format:

```
## Plan Review: <plan filename>

### ✅ What's solid
- ...

### ❌ Issues (must fix before execution)
- Section — <issue> — <suggested rewrite or fix>

### ⚠️ Suggestions (recommended but not blocking)
- Section — <issue> — <suggested improvement>

### Verdict
READY | NEEDS CHANGES
```

Self-review the proposed changes (inherits from /make-plan Step 4):
1. Can any two issues be merged without losing clarity? Merge them.
2. Is any suggestion redundant with an existing plan section? Remove it.
3. Are there suggested rewrites that introduce new ambiguity? Rewrite them.

Present the report to the user.

---

## Step 5: Confirm and Save

Ask: "Apply these changes to the plan?"

Apply any user edits to the approved changes.
Update the plan file in place with all approved improvements.

If the plan status was `planning` and all blocking issues are resolved → update status to `approved`.
Otherwise → keep status unchanged.

Print: "Plan updated. Run /execute-plan <filename> to begin implementation."

Do NOT write any code or suggest any implementation.
