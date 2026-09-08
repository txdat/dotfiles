# Dev Skills

## Hierarchy

```
/frame-goal — every fresh requirement enters here, then routes by shape
    ↓ boundary-shaped/feature-shaped goal
/design-system → /review-system → architecture approval
    ↓ each phase enters the application lane when dependencies permit
/design-feature → /review-feature → spec approval → RED → GREEN → BLUE
```

A third lane runs beside these, for work on live infrastructure:

```
/design-infra → /review-infra → READY → human executes → /review-infra post
```

**The agent never executes it** (`design-infra` `The agent never executes`) — every phase is read-only, and the human runs the runbook on their own authority. That is why the lane has no `approval.md` pause: the decision to execute is the human's and happens outside this flow. No worktree, no execute/review-code/PR phase, and its own statuses (`draft → executed`, or `abandoned`) rather than plan state. Infra work that also changes application code splits, and the code half takes the feature lane on its own plan.

Architecture uses a separate falsifiable chain: goal and constraints → options → recommendation → boundary contracts → reversible phases → measured outcome. Independent review precedes human approval. Each approved contract is assigned to a feature plan, where observable behavior enters Goal → AC → TC → RED → GREEN → BLUE; architecture never replaces the feature Goal.

## Full Feature Cycle

`/dev:ship-feature <requirement>` — [explore] → frame-goal → design-feature → review-feature → spec approval → execute → review-code → PR. The six phases after `frame-goal` are mandatory; `explore` is optional (PROCESS #8). Resume by naming the plan: `/dev:ship-feature docs/plans/<file>.md from <phase>`. A bare `<requirement>` always starts a new design.

Plan review derives expected outcomes from `## Goal` before reading proposed TC intents. It returns READY; it never approves. Required decisions and semantic AC/TC amendments block readiness; optional refinements do not. Non-critical verification uncertainty may enter `## Open Risks` when existing TC intents can settle it. Authorized delivery includes independent re-review of in-scope fixes; review-only requests remain read-only. `independence.md` owns these boundaries and escalation when revisions stop making progress.

Plan statuses are enumerated in `PROCESS.md` `Lifecycle`, and `approval.md` owns the two terminal ones. `archived` is create-pr's own last step once the PRs exist; `abandoned` is a human decision.

`archived` means the PR exists and the cycle is closed — **not merged, not deployed**. What that implies for follow-up work, and where a follow-up parents, is `create-pr.md` `Shipped, and what comes after`.

**Every approval is the human's, and `approval.md` is the single source** for both the application spec and the architecture decision. `gate-check` refuses execution without `Status: approved` (`approval.md`).

Know what enforces what: PROCESS `Self-check boundary`. Short version — the hook proves state, the self-checks prove correctness, and the pause proves consent.

**BDD then TDD.** BDD owns `Goal → AC → TC intent` and answers whether the right behavior is specified; the TC's Given/When/Then body is authored at RED, where its vacuity and constructibility are settled by a runner instead of argued in prose. TDD consumes only approved TCs through RED → GREEN → BLUE and answers whether code implements that behavior. Passing TCs never overrides a failed AC or Goal; contradictions return to design/review and human reapproval.

**One lane, scaled to the change.** There is no lite mode. A small change gets a short plan because it has little to say, not because a flag excused it — and Goal, ACs, TCs, adversarial review, the approval pause, RED proof, coverage, and symbol gates apply to every change regardless of size.

**Named plan, always** (PROCESS `Named plan and entry gates`). Every dev skill ends with a blocking self-check — no exit line until verified against the artifacts (PROCESS #2).

## Loading

Nothing in this tree is preloaded. `PROCESS.md` loads before plan-backed work and includes the phase skills table. `CODING.md` loads before the first code read or write. Each skill — plus the single-source files it names — loads at invocation.

## AI project configuration

Every skill opens with "read AI project configuration" — the nearest `CLAUDE.md`/`AGENTS.md`, plus includes. Read once per phase. Overrides only _how code is written_; never a core rule, skill gate, or banned tool.

---

## Single-Source Files

Read by the skills that need them. Phase files may name their gates but do not redefine these rules: `approval.md` (both human decisions) · `independence.md` (delegated review) · `altitude.md` (plan is design, not code) · `tdd.md` (RED→GREEN→BLUE) · `coverage.md` (measurement, bands, test quality bar) · `worktree.md` (lifecycle) · `dependents.md` (blast radius) · `frontend-design.md` (visual design direction for UI/frontend work).

`sverklo.md` sits in this tree but is not one of them: it is a tool guide that `CODING.md`'s navigation cascade loads when the Sverklo tier is needed and its tools are available. No dev skill reads it.

## Design Skills

| Skill                 | Scope                                                                                                            | Output                                                 |
| --------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `/dev:frame-goal`     | Frame a requirement into confirmed goal(s); split too-broad, question ambiguous; runs ahead of both design lanes | goal list, routed by shape; deferred goals tracked in the parent issue |
| `/dev:design-system`  | Boundaries, communication, decomposition                                                                         | `docs/architecture/<date>_<slug>.md`                   |
| `/dev:design-feature` | Feature/fix/refactor                                                                                             | `docs/plans/<basename>_<date>_<type>_<slug>.md`        |
| `/dev:design-infra`   | Infrastructure runbook (migration, shutdown, DNS cutover, terraform, maintenance)                                 | `docs/runbooks/<date>_<slug>.md`                       |

## Review Skills

| Skill                 | Reviews             |
| --------------------- | ------------------- |
| `/dev:review-system`  | Architecture design |
| `/dev:review-feature` | Feature plan        |
| `/dev:review-infra`      | Infrastructure runbook before execution (live-state validation) |
| `/dev:review-infra post` | What actually ran, after the human executed (audit + Execution Record) |
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
| `/dev:recap <plan-path-or-archive-comment>` | Session lessons and workflow improvement proposals ([draft](recap.md)) |
