# /ship-feature — Gated Delivery Router

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

Flow: [explore] → frame-goal → design-feature → review-feature → spec approval → execute-feature → review-code → create-pr. `explore` is optional (PROCESS #10); `frame-goal` always runs on a fresh requirement but collapses to a one-line pass-through when it is already a single clear goal — its pause fires only on a split, rewrite, or question. Read project config for AI. `$ARGUMENTS`: `<requirement>` to start, or `docs/plans/<file>.md [from <phase>]` to resume.

ship-feature drives **one goal's lane at a time**: frame-goal's goal 1 proceeds through design and onward; deferred goals live as issues and each ships later through its own ship-feature run.

## Route

A bare `<requirement>` always starts a new design and adopts no existing plan; resuming names its plan path (PROCESS `Named plan and entry gates`). Use an explicit `from` phase or the named plan's live header. Route on `Status:` **and** `Review:` — never on session memory of what already ran:

| Status | `Review:` | Next |
|---|---|---|
| no plan | — | frame-goal, then design-feature with the first confirmed goal (explore first when the area is unfamiliar — optional, per PROCESS #10; a boundary-shaped goal detours through design-system → review-system before its feature plans, per frame-goal's routing) |
| `planning` | empty | review-feature, once Open Questions are empty |
| `planning` | `READY <date>` | `approval.md` spec pause |
| `approved` / `in-progress` | `READY <date>` | execute-feature |
| `approved` / `in-progress` | empty | STOP — approved without a recorded review; return to review-feature |
| `implemented` | — | review-code |
| `reviewed` | — | create-pr |
| `archived` | — | STOP — already shipped |
| `abandoned` | — | STOP — dropped; reviving re-enters at `planning` (`approval.md`) |

Once a plan exists, pass its explicit path to every downstream phase. A phase is complete only when its owner passes its self-check.

## Approval

Read and follow `approval.md` (single source). ship-feature runs its pause; it never adds an exception to it.

## Rework

A contradiction or blocking plan defect found during execution or review clears `Review:`, returns the plan to `planning`, and sends it through review-feature and back to the approval pause. Cosmetic observations do not.

## Self-Check (BLOCKING)

- [ ] **Route:** live `Status:` + `Review:` and the explicit plan path select the correct next phase.
- [ ] **Approval:** `Status: approved` came from an explicit human answer at `approval.md`'s pause, never from me, and the plan carried `Review: READY` when asked; re-planning got fresh review and a fresh pause.
- [ ] **Completion:** each owning phase completed before advancing; shipping ends only with PR URL(s) and `archived` status.
