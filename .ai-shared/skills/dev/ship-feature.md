# /ship-feature — Gated Delivery Router

Flow: [explore] → design-feature → review-feature → spec approval → execute-feature → review-code → create-pr. Only `explore` is optional (CORE #10). Read project AI config. `$ARGUMENTS`: `<requirement> [from <phase>]`.

## Route

Use an explicit `from` phase or the active plan's live header. Route on `Status:` **and** `Review:` — never on session memory of what already ran:

| Status | `Review:` | Next |
|---|---|---|
| no plan | — | design-feature (explore first when the area is unfamiliar — optional, per CORE #10) |
| `planning` | empty | review-feature, once Open Questions are empty |
| `planning` | `READY <date>` | `approval.md` spec pause |
| `approved` / `in-progress` | `READY <date>` | execute-feature |
| `approved` / `in-progress` | empty | STOP — approved without a recorded review; return to review-feature |
| `implemented` | — | review-code |
| `reviewed` | — | create-pr |
| `archived` | — | STOP — already shipped |

Once a plan exists, pass its explicit path to every downstream phase. A phase is complete only when its owner passes its self-check.

## Approval

Read and follow `approval.md` (single source). ship-feature runs its pause; it never adds an exception to it.

## Rework

A contradiction or blocking plan defect found during execution or review clears `Review:`, returns the plan to `planning`, and sends it through review-feature and back to the approval pause. Cosmetic observations do not.

## Self-Check (BLOCKING)

- [ ] **Route:** live `Status:` + `Review:` and the explicit plan path select the correct next phase.
- [ ] **Approval:** `Status: approved` came from an explicit human answer at `approval.md`'s pause, never from me, and the plan carried `Review: READY` when asked; re-planning got fresh review and a fresh pause.
- [ ] **Completion:** each owning phase completed before advancing; shipping ends only with PR URL(s) and `archived` status.
