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

Any later change to the Goal, an AC, or a TC — during execution, review, or re-planning — clears `Review:`, returns `Status: approved` to `planning`, and takes the plan back through review-feature and this pause. Never edit approved behavior in place.

This is not a deviation. A **deviation** is a different *means* to the same approved behavior: log it under `## Deviations` per PROCESS #5 and keep going. A change to the *behavior itself* comes back here. If you cannot tell which one you are looking at, it is this one.

### What happens to work already committed

A behavior change found mid-execution leaves proof and implementation commits in the worktree for a spec that is no longer approved. The worktree and its branch survive the round trip; what comes out is scoped by commit boundaries, not by TC:

1. **Reversion granularity is the commit, not the TC.** `execute-feature` bundles a slice's TCs into one proof/GREEN pair, so a TC cannot be extracted from its siblings. Revert **whole pairs**: the pair holding the amended TC comes out entirely and that slice re-enters at RED with its revised TC set, siblings included.
2. **Other slices keep everything.** A slice whose TCs are all unaffected keeps its proof and GREEN commits; re-approval does not invalidate behavior that did not change.
3. **Revert, never reset** — the branch keeps the record of what was built and withdrawn. A dropped TC ends there; survivors re-enter at RED after re-approval. `tdd.md` step 3 does not apply: the old proof is gone, not reused.
4. **Then flip status in the worktree copy** (`planning`, `Review:` cleared) and commit it, per PROCESS `Plan worktree`. `gate-check` will refuse execution until the plan carries `Review: READY` and an explicit approval again.

Never carry a reverted TC's implementation forward "since it's already written". That is the approved-spec equivalent of a fake implementation: code whose only warrant was a spec that no longer exists.

### Scope of the re-approval

The pause is not optional and not implied, but it is scoped: on an amendment, show the Goal plus **the changed AC/TC subgraph and everything traceable to it** — not the full spec replayed. Ask the same question. Everything else about the pause is unchanged: silence, urgency, and "we already agreed on the rest" are still not approvals, and review-feature still runs first on the amended plan.

## Abandoning a plan

Dropping a plan before it ships is the human's call, on the same authority as granting approval — propose it, never decide it. On an explicit answer:

1. `Worktree:` recorded → remove the worktree and its branch from `$MAIN_ROOT`, requiring a clean tree first and showing any refusal instead of forcing it. A plan dropped at `planning` or `approved` never had one; skip this.
2. In `$MAIN_ROOT`'s locator copy, set `Status: abandoned`, clear `Worktree:`, and record in one line what was dropped and why.

Abandonment is the inverse of archival, so the record lives in the opposite place. `archived` survives on a branch that merges, which is why create-pr commits it there and deletes the locator; a dropped branch takes its plan copy with it, leaving the locator as the only surviving record — and the only one `gate-check` can see, since it scans `$MAIN_ROOT/docs/plans/`. Write `abandoned` anywhere else and no surviving record says the plan was dropped: the locator keeps reading as active, and `gate-check` — which scans `$MAIN_ROOT/docs/plans/` — will let a later phase be pointed at it and gated on it as live work.

`abandoned` and `archived` are the two terminal statuses: both leave the active set, and neither is an entry status, so an abandoned plan blocks at whatever gate it is aimed at. Reviving one is not a status edit — it re-enters at `planning` and comes back through review-feature and the spec pause above.

## What is enforced, and what is not

`gate-check` blocks execution unless `Status: approved` **and** `Review: READY` are both set. That is the whole mechanical guarantee — it proves a review happened before the approval, and nothing more. It cannot tell who set either field, and no parser can check that an AC is the right AC.

So the pause is the enforcement, and the judgment lives in review-feature's adversarial self-check: can a TC pass while its AC fails, can every AC pass while the Goal fails. Treat a plan that reached `approved` without a human answering the question above as unapproved, whatever the file says.
