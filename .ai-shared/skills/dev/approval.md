# Approval — Single Source

Owns every human approval in the dev flow: the **application spec** (`Type: feature|fix|refactor` plans) and the **architecture decision** (`docs/architecture/**`). No other file states, restates, or qualifies the conditions of approval; they point here.

## Application spec

One decision, one pause. Precondition: the plan carries `Review: READY <date>` from an actual review-feature verdict. Missing → there is nothing to approve yet; run review-feature.

1. Show the Goal, then every AC and TC by ID — each on its own line, full text, no summarizing. Add slice/step counts, key risks, and issue state.
2. Ask: **`Approve this spec? Reply "approve", or name the AC/TC IDs to revise or drop.`**
3. Pause. Only an explicit approval sets `Status: approved`.

A response that names IDs is a revision: apply the edit, delete a dropped item outright (git history is the audit trail — do not keep tombstones), and route back through review-feature before asking again.

Silence, a general "proceed", prior agreement on the Goal, urgency, and a bug report are **not** approvals. Neither is your own confidence. Nothing else in the flow may set `Status: approved`.

## Architecture

Same shape, different artifact, and it happens **before** any feature plan is written. Precondition: review-system reported `READY` on a `Status: draft` document.

1. Show the recommendation, the decisive trade-offs, the phases, and the plan decomposition.
2. Ask: **`Approve this architecture? Reply "approve", or name what to revise.`**
3. Pause. Only an explicit approval sets `Status: approved` on the document. Revisions return through design-system and review-system.

Approving an architecture approves *boundaries*, never application behavior: each decomposed feature plan still comes back through the spec pause above. Any later semantic change returns the document to `draft` for fresh review and a fresh pause.

## Changing an approved spec

Never edit approved behavior in place. Any later change to the Goal, an AC, or a TC — during execution, review, or re-planning — clears `Review:`, returns `Status: approved` to `planning`, and takes the plan back through review-feature and this pause.

A **deviation** is the opposite case: same approved behavior, different *means*. Log it under `## Deviations` per PROCESS #5 and keep going. If you cannot tell which one you are looking at, it is this one.

### What happens to work already committed

A behavior change found mid-execution leaves proof and implementation commits for a spec no longer approved. The worktree and branch survive the round trip; reversion is scoped by commit boundaries, not by TC:

1. **Revert whole proof/GREEN pairs.** A slice's TCs are bundled into one pair, so a TC cannot be extracted from its siblings. The pair holding the amended TC comes out entirely; that slice re-enters at RED with its revised TC set, siblings included.
2. **Other slices keep everything.** Unaffected slices keep their proof and GREEN commits.
3. **Revert, never reset.** The branch keeps the record of what was built and withdrawn. Survivors re-enter at RED after re-approval; the old proof is gone, not reused.
4. **Flip status in the worktree copy** (`planning`, `Review:` cleared) and commit it. `gate-check` refuses execution until `Review: READY` and explicit approval again.

Never carry a reverted TC's implementation forward "since it's already written" — code whose only warrant was a spec that no longer exists.

### Scope of the re-approval

The pause is scoped, not skipped: on an amendment, show the Goal plus **the changed AC/TC subgraph and everything traceable to it** — not the full spec replayed. Ask the same question. Everything else about the pause is unchanged; review-feature still runs first on the amended plan.

## Abandoning a plan

Dropping a plan before it ships is the human's call, on the same authority as granting approval — propose it, never decide it. On an explicit answer:

1. `Worktree:` recorded → remove the worktree and its branch from `$MAIN_ROOT`, requiring a clean tree first and showing any refusal instead of forcing it. A plan dropped at `planning` or `approved` never had one; skip this.
2. In `$MAIN_ROOT`'s locator copy, set `Status: abandoned`, clear `Worktree:`, and record in one line what was dropped and why.

Abandonment is the inverse of archival, so the record lives in the opposite place. `archived` survives on a merged branch, which is why create-pr commits it there and deletes the locator; a dropped branch takes its plan copy with it, leaving the locator as the only surviving record `gate-check` can see. Write `abandoned` anywhere else and the locator keeps reading as active, letting a later phase be gated on it as live work.

`abandoned` and `archived` are the two terminal statuses: both leave the active set, and neither is an entry status, so an abandoned plan blocks at whatever gate it is aimed at. Reviving one is not a status edit — it re-enters at `planning` and comes back through review-feature and the spec pause above.

## What is enforced, and what is not

`gate-check` blocks execution unless `Status: approved` **and** `Review: READY` are both set — it proves a review happened before approval, nothing more. The pause is the enforcement; the judgment lives in review-feature's adversarial self-check. Treat a plan that reached `approved` without a human answering the question above as unapproved, whatever the file says.
