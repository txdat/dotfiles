# Approval — Single Source

Owns the exact prompt, pause, and revision procedure for every human approval in the dev flow: the **application spec** (`Type: feature|fix|refactor` plans) and the **architecture decision** (`docs/architecture/**`). Other files may name the gate and its entry state; they do not redefine it.

## Application spec

One decision, one pause.

1. Show the Goal, then every AC and TC by ID — each on its own line, full text, no summarizing. Add slice/step counts, key risks, and issue state.
2. Ask: **`Approve this spec? Reply "approve", or name the AC/TC IDs to revise or drop.`**
3. Pause. Only an explicit approval sets `Status: approved`.

A response that names IDs is a revision: apply the edit, delete a dropped item outright (the issue comment preserves the final plan — do not keep tombstones), and route back through review-feature before asking again.

Silence, a general "proceed", prior agreement on the Goal, urgency, and a bug report are **not** approvals. Neither is your own confidence. Nothing else in the flow may set `Status: approved`.

Explicit acceptance in native plan mode also satisfies this gate when it presents the same reviewed spec for approval. Preserve valid approval of that unchanged spec on resume; do not ask twice.

## Architecture

Same shape, different artifact, and it happens **before** any feature plan is written. Precondition: review-system reported `READY` on a `Status: draft` document.

1. Show the recommendation, the decisive trade-offs, the phases, and the plan decomposition.
2. Ask: **`Approve this architecture? Reply "approve", or name what to revise.`**
3. Pause. Only an explicit approval sets `Status: approved` on the document. Revisions return through design-system and review-system.

Approving an architecture approves *boundaries*, never application behavior: each decomposed feature plan still comes back through the spec pause above. Any later semantic change returns the document to `draft` for fresh review and a fresh pause.

## Changing an approved spec

Edit the main-tree plan before a worktree exists; afterwards edit only its authoritative worktree copy.

Classify the change by meaning. An editorial correction preserves outcomes, scenarios, thresholds, contracts, and verification obligations. Record it briefly under `## Review History`; retain approval and status. Correcting `Test: path::name` is evidence maintenance only when the reference still identifies the same scenario with applicable proof. Missing or previously unreviewed evidence is a verification gap: a `reviewed` plan returns to `implemented` until independent review settles it. If equivalence is uncertain, investigate before treating the change as editorial.

A semantic amendment adds, removes, or changes an approved outcome, scenario, constraint, or verification obligation. Set the authoritative plan to `planning`, record the affected Goal/AC/TC IDs and reason in `## Review History`, and prepare the revised spec. It must pass review-feature and the human approval pause before dependent implementation resumes. `independence.md` governs whether existing authorization includes revision and re-review. An Open Risk never authorizes a semantic amendment.

A **deviation** preserves approved behavior and scope while changing specified implementation details. PROCESS #4 owns its record and risk checks: routine changes continue, material changes require a decision. If behavioral impact is uncertain, investigate first and ask if the uncertainty remains; do not classify uncertainty as permission to proceed.

### What happens to work already committed

Preserve the worktree, branch, and unaffected commits. Editorial corrections invalidate no behavioral proof. For a semantic amendment, identify which tests, proof, and implementation no longer satisfy the revised spec; do not count historical evidence as proof of changed behavior.

After reapproval, rework the affected behavior with the applicable `tdd.md` proof and rerun affected tests. Revert or replace only invalidated changes when they can be separated safely. Revert a whole proof/GREEN pair only when the affected portion cannot be separated without breaking its remaining behavior or evidence. Preserve Git history rather than resetting it. Review must account for retained and replaced evidence against the current spec before publication.

### Scope of the re-approval

The pause is scoped, not skipped: on an amendment, show the Goal plus **the changed AC/TC subgraph and everything traceable to it** — not the full spec replayed. Ask the same question. Everything else about the pause is unchanged; review-feature still runs first on the amended plan.

## Abandoning a plan

Dropping a plan before it ships is the human's call, on the same authority as granting approval — propose it, never decide it. On an explicit answer:

1. `Worktree:` recorded → remove the worktree and its branch from `$MAIN_ROOT`, requiring a clean tree first and showing any refusal instead of forcing it. A plan dropped at `planning` or `approved` never had one; skip this.
2. In `$MAIN_ROOT`'s locator copy, set `Status: abandoned`, clear `Worktree:`, and record in one line what was dropped and why.
3. Plan links a shared parent issue → tick and strike this goal's entry, mirroring `frame-goal`'s spike convention: `- [x] ~<goal sentence>~ — abandoned (plan)`. An abandoned goal ships no PR, so nothing else will ever tick it — and `create-pr`'s closure check reads exactly these boxes, so skipping this strands the parent open forever.

Each terminal status has exactly one surviving record. `archived` → create-pr posts the plan as an issue comment and deletes local copies. `abandoned` → the branch is removed, taking the worktree copy; the locator stays as the only record `gate-check` can see. Write `abandoned` anywhere else and the locator keeps reading as active, letting a later phase be gated on it as live work.

`abandoned` and `archived` are the two terminal statuses: both leave the active set, and neither is an entry status, so an abandoned plan blocks at whatever gate it is aimed at. Revival requires a fresh planning artifact, review-feature, and the spec pause; never reopen the terminal plan.

## What is enforced, and what is not

`gate-check` blocks execution unless `Status: approved` is set. Human approval is the consent requirement; the judgment lives in review-feature's adversarial self-check. Treat a plan that reached `approved` without valid human approval under this procedure as unapproved, whatever the file says.
