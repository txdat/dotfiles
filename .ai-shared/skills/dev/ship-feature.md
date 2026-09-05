# /ship-feature — Gated Delivery Router

If `~/.dotfiles/.ai-shared/PROCESS.md` is not yet loaded, read it first.

Flow: [explore] → frame-goal → design-feature → review-feature → spec approval → execute-feature → review-code → create-pr. `explore` is optional (PROCESS #8); `frame-goal` always runs on a fresh requirement but collapses to a one-line pass-through when it is already a single clear goal — its pause fires only on a split, rewrite, or question. Read AI project configuration. `$ARGUMENTS`: `<requirement>` to start, or `docs/plans/<file>.md [from <phase>]` to resume.

ship-feature drives **one goal's lane at a time**: frame-goal's goal 1 proceeds through design and onward; deferred goals wait as checklist entries in the requirement's parent issue and each ships later through its own ship-feature run, its plan linking that same parent.

## Route

A bare `<requirement>` always starts a new design and adopts no existing plan; resuming names its plan path (PROCESS `Named plan and entry gates`). Use an explicit `from` phase or the named plan's live header. Route on `Status:` — never on session memory of what already ran:

| Status | Next |
|---|---|
| no plan | frame-goal, then design-feature with the first confirmed goal (explore first when the area is unfamiliar — optional, per PROCESS #8; a boundary-shaped goal detours through design-system → review-system before its feature plans, per frame-goal's routing) |
| `planning` | review-feature once Open Questions are empty. On `READY`, `approval.md` spec pause |
| `approved` / `in-progress` | execute-feature |
| `implemented` | review-code |
| `reviewed` | create-pr |
| `archived` | STOP — already shipped |
| `abandoned` | STOP — dropped; reviving re-enters at `planning` (`approval.md`) |

Once a plan exists, pass its explicit path to every downstream phase. A phase is complete only when its owner passes its self-check.

## Approval

Read and follow `approval.md` (single source). ship-feature runs its pause; it never adds an exception to it.

## Rework

Within authorized delivery, correct implementation defects against the approved spec, verify affected behavior, and route independent re-review under `independence.md`. Keep changed implementation at `implemented` until review passes. Editorial spec corrections preserve status; semantic amendments return to `planning` and require review and human reapproval under `approval.md` before dependent implementation resumes.

Apply `independence.md`'s two-pass repair budget. Pause when it is exhausted, a decision falls outside authorization, or a blocking finding recurs without progress. Report what is needed to continue. A review-only or edit-only request retains its narrower scope.

## Self-Check (BLOCKING)

- [ ] **Route:** live `Status:` and the explicit plan path select the correct next phase.
- [ ] **Approval:** `Status: approved` came from an explicit human answer at `approval.md`'s pause, never from me; re-planning got fresh review and a fresh pause.
- [ ] **Completion:** each owning phase completed before advancing; shipping ends with PR URL(s) and `archived` status, or a concrete unresolved decision, evidence gap, or authorization boundary. Revisions were independently re-reviewed within the authorized scope.
