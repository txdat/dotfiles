# Dev Skills

## Hierarchy

```
/frame-goal — every fresh requirement enters here, then routes by shape
    ↓ boundary-shaped goal                ↓ feature-shaped goal
/design-system → /review-system → architecture approval
    ↓ each phase enters the application lane when dependencies permit
/design-feature → /review-feature → spec approval → RED → GREEN → BLUE
```

Architecture uses a separate falsifiable chain: goal and constraints → options → recommendation → boundary contracts → reversible phases → measured outcome. Independent review precedes human approval. Each approved contract is assigned to a feature plan, where observable behavior enters Goal → AC → TC → RED → GREEN → BLUE; architecture never replaces the feature Goal.

## Full Feature Cycle

`/dev:ship-feature <requirement>` — [explore] → frame-goal → design-feature → review-feature → spec approval → execute → review-code → PR

`explore` is optional and the six phases after `frame-goal` are not (PROCESS #10). `frame-goal` frames the requirement into confirmed goal(s) — single source for the too-broad test — routes each goal to design-system or design-feature by shape, and collapses to a pass-through when the requirement is already one clear goal; it pauses only on a split, rewrite, or question.

Resume: `/dev:ship-feature docs/plans/<file>.md from execute` — resuming names its plan; `ship-feature <requirement>` always starts a new design and adopts nothing.

Plan review enforces the Open Questions gate and does the real work: it independently derives the expected outcomes from `## Goal` before reading the proposed TC intents, then attacks the AC set with counterexamples. It returns READY; it never approves. It is bounded — two rounds plus landing checks, counted durably in the plan header's `Rounds:` field so the budget survives pruned history and compacted sessions — and may never add behavior: after handoff the AC set only narrows, and a missing outcome becomes a proposed extension plan with its own Goal and approval, never a round-N AC.

Plan statuses are enumerated in `README.md` `Lifecycle`, and `approval.md` owns the two terminal ones. `archived` is create-pr's own last step once the PRs exist; `abandoned` is a human decision.

`archived` means the PR exists and the cycle is closed — **not merged, not deployed**. What that implies for follow-up work, and where a follow-up parents, is `create-pr.md` `Shipped, and what comes after`.

**Every approval is the human's, and `approval.md` is the single source** — both the application spec and the architecture decision. Nothing else in this tree states when approval is granted; they point there. A plan reaches the pause only carrying `Review: READY <date>` from review-feature, and `gate-check` refuses to execute an `approved` plan without it.

Know what enforces what: PROCESS `Self-check boundary`. Short version — the hook proves state, the self-checks prove correctness, and the pause proves consent.

**BDD then TDD.** BDD owns `Goal → AC → TC intent` and answers whether the right behavior is specified; the TC's Given/When/Then body is authored at RED, where its vacuity and constructibility are settled by a runner instead of argued in prose. TDD consumes only approved TCs through RED → GREEN → BLUE and answers whether code implements that behavior. Passing TCs never overrides a failed AC or Goal; contradictions return to design/review and human reapproval.

**One lane, scaled to the change.** There is no lite mode. A small change gets a short plan because it has little to say, not because a flag excused it — and Goal, ACs, TCs, adversarial review, the approval pause, RED proof, coverage, and symbol gates apply to every change regardless of size.

**Named plan, always.** Every plan-consuming skill takes an exact `docs/plans/<file>.md` — no slug, no session pin, no lone-plan adoption. See PROCESS `Named plan and entry gates`.

Every dev skill ends with a blocking self-check. Do not emit the skill's exit line until that checklist is verified against the artifacts.

## Loading

Nothing in this tree is preloaded; only `README.md` auto-loads. Everything else is read at its trigger (`README.md` `Load on demand`): `PROCESS.md` before plan-backed work, `CODING.md` before the first code read or write, this file when you need the flow overview, `approval.md` at its pause, and each skill — plus the single-source files it names — at invocation.

## Project Config For AI

Every skill opens with "read project config for AI". That means the nearest `CLAUDE.md/AGENTS.md` at or above the repo root, plus any file it includes. Read it once per phase. Per `README.md` precedence it may override exactly one thing — _how code is written_ (style, naming, layout, stack-local patterns, project commands) — and never a core rule, a skill gate, or a banned tool.

---

## Single-Source Files

Read by the skills that need them; never restated. `approval.md` (both human decisions) · `independence.md` (delegated review) · `altitude.md` (plan is design, not code) · `tdd.md` (RED→GREEN→BLUE) · `coverage.md` (measurement, bands, test quality bar) · `worktree.md` (lifecycle) · `dependents.md` (blast radius).

## Design Skills

| Skill                 | Scope                                                                                                            | Output                                                 |
| --------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `/dev:frame-goal`     | Frame a requirement into confirmed goal(s); split too-broad, question ambiguous; runs ahead of both design lanes | goal list, routed by shape; deferred goals tracked in the parent issue |
| `/dev:design-system`  | Boundaries, communication, decomposition                                                                         | `docs/architecture/<date>_<slug>.md`                   |
| `/dev:design-feature` | Feature/fix/refactor                                                                                             | `docs/plans/<basename>_<date>_<type>_<slug>.md`        |

## Review Skills

| Skill                 | Reviews             |
| --------------------- | ------------------- |
| `/dev:review-system`  | Architecture design |
| `/dev:review-feature` | Feature plan        |
| `/dev:review-code`    | Code changes        |

## Execution Skills

| Skill                             | Purpose                                                 |
| --------------------------------- | ------------------------------------------------------- |
| `/dev:execute-feature`            | TDD RED→GREEN→BLUE                                      |
| `/dev:fix-bug diagnose <symptom>` | Read-only root-cause diagnosis                          |
| `/dev:fix-bug execute <fix-plan>` | Execute an already reviewed and human-approved fix plan |

## Utility Skills

| Skill                       | Purpose                          |
| --------------------------- | -------------------------------- |
| `/dev:explore <target>`     | Map entry points, flow, patterns |
| `/dev:create-issue <title>` | Standalone GitHub issue          |
| `/dev:create-pr [ready]`    | Draft PR (or ready)              |
