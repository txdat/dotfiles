# AI — Process

Orchestration rules for plan-backed work (main session only). If `~/.dotfiles/.ai-shared/CODING.md` is not yet loaded, read it first.

## Compliance (non-negotiable)

These override all other tendencies. Violating one → STOP and self-correct.

1. **Gates are hard blocks.** A skill instruction that says STOP or BLOCKING ends forward progress: report the gate, wait. A `bin/gate-check` block ends it too — STOP and satisfy the prerequisite. Inferring what the user would have wanted is not a way past one, and neither is rephrasing an invocation to evade the hook.

2. **Self-checks gate the completion signal.** Run a skill's `## Self-Check` against the artifacts actually produced — not against intent — before emitting its exit line (the phase's closing message; not the `handoff` skill's session snapshot). Unchecked box → fix, re-check; emit only when all pass.

3. **RED before GREEN.** No feature/fix implementation before a failing `test(red): <scope>` commit exists. That commit is tests-only (+ throwing stubs, zero implementation). Refactors require a passing `test: baseline <scope>` commit before changes. If the required test commit doesn't exist for the current slice → write the test/baseline, commit it, then proceed.

4. **Plan deviations are NOT free calls.** A deviation is same goal, different means than the plan specifies — a different approach or Design Decision, a substituted symbol/signature, a changed step structure, a different file/module. (Distinct from scope creep, which is *new* work — see #6.) Before implementing the divergence → STOP. Log in `## Deviations`: Plan said / Doing instead / Why (what forced it) / Tradeoff (gained vs lost, risk introduced). Ask: proceed / follow plan / re-plan. Never deviate silently.

5. **Coverage gates are numeric — the number is a floor, not a score.** Coverage proves exercise, not correctness. Can't assert meaningfully → log a Coverage Gap; never write a test to raise the number (CODING `Report, don't decide`; smells: coverage.md `Quality bar`).

   **Bands.** Gate the lines *this change* touched, never the repo-global number: ≥90% → ✅ · 80–89% → ⚠️ log and **continue** · <80% → ❌ STOP and ask.

   **Stricter-only.** A reason can only move the verdict down, never up. Every ⚠️/❌ names *which* lines are uncovered and *which behavior* each belongs to. An uncovered critical path (auth / money / rollback / data-integrity) is ❌ even at ≥90%.

   **Carry, don't close.** A ⚠️ is logged and carried — never Discovered Scope, never a STOP. Closing a gap goes through behavior, never lines; a missing TC can surface as PROCESS #6 work only when closing a ❌ or chosen ⚠️.

   Mechanics — branch-vs-line, patch granularity, denominator curation, the mock caveat — live in `~/.dotfiles/.ai-shared/skills/dev/coverage.md` (single source for measurement; PROCESS owns the gates so coverage can't relax them).

6. **Scope creep → STOP.** Work discovered beyond the plan is NOT a bonus. Log it in `## Discovered Scope` with estimated effort. Ask: include / separate / skip. Never silently expand scope.

7. **Open Questions are a hard gate.** If a plan's `## Assumptions & Open Questions` → `Open Questions:` field contains any real unresolved item, the plan is NOT ready for review. Empty markers such as `none` or `n/a` are allowed; placeholders or bullets are not. If a review finds unresolved Open Questions → verdict is NEEDS CHANGES, route back to design. Never proceed past an open question.

8. **No skipped phases for plan-backed work.** The mandatory chain is: **design-feature → review-feature → spec approval → execute → review-code → PR.** These six cannot be skipped or reordered. `explore` is an optional precursor, not a gate. `frame-goal` precedes the chain on every fresh requirement — collapsing to a pass-through when the requirement is already one clear goal — and hands each confirmed goal to its design lane. Entry-point utilities (`explore`, `create-issue`, `fix-bug diagnose`) never touch application code; every path that mutates application code runs through an approved plan. There is no planless-mutation lane — behavior-preserving cleanup is a `Type: refactor` plan like any other change.

9. **Application behavior is the human's call.** Feature/fix/refactor plans preserve `## Goal` and trace `Goal → AC ↔ TC ↔ Step`. Design and review may propose or refine behavior; only the user approves it at the pause defined in `~/.dotfiles/.ai-shared/skills/dev/approval.md`, the single source for the exact prompt and revision procedure. Other files may name this gate but never relax or redefine it. No inferred, prior-agreement, urgency, or fix-bug exception. Approval is reachable only after review: a plan reaches the pause carrying `Review: READY <date>` in its header, written by review-feature, and `gate-check` refuses execution of an `approved` plan without it. Changing approved behavior later clears `Review:`, returns the plan to `planning`, and sends it back through review and that pause; a different *means* to the same behavior is an ordinary PROCESS #4 deviation.

## Conventions
**Git credentials.** All git/GitHub actions run under the credential already configured in this environment: the token stored by `gh auth login` for GitHub operations, and `git config user.name`/`user.email` wherever an author is required. Read the identity from there — never assume, invent, or hardcode one. Route GitHub ops through `gh` and rely on its stored credential; never hardcode a token, inject `GITHUB_TOKEN`/`GH_TOKEN`, or switch to a different account than the one already active. `gh auth status` showing no authenticated account, or an author being required with `user.name` unset → STOP, report, wait.

**Base branch (`<base>`):** `BASE=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|.*/||' || echo main)`. Skill docs use `<base>` to refer to this.

**Plan worktree (`<worktree>`):** every plan gets one git worktree at `~/work/ai-worktrees/<repo-basename>-<slug>`, created by execute-feature/fix-bug and reused by every later skill (review-code, create-pr) until create-pr removes it. Once it exists, the worktree copy of the plan is the plan's **single source of truth**: read `Status:` and every section from it, and make **and commit** every plan edit (status flips, PR-Pattern finalization, Deviations) inside `<worktree>`. All git/gh commands for the plan run there (`cd <worktree>` or `git -C <worktree>`), never in the main working tree. Everything else is `~/.dotfiles/.ai-shared/skills/dev/worktree.md` (single source): resolution from the `$MAIN_ROOT` locator, create, plan copy, dependency symlinks, resume/ancestry checks, `$MAIN_ROOT` sharing, teardown.

**Named plan and entry gates.** Governance binds to a named artifact: every plan-consuming skill takes an exact `docs/plans/<file>.md`. No slug matching, session pin, or silent adoption of the active plan — a dormant plan can never capture unrelated work, and no gate fires merely because a plan exists. Unnamed → STOP and ask for the path. A plan is *active* while its `Status:` is neither of the terminal two, `archived` and `abandoned`; terminal plans are inert and are not entry statuses. `ship-feature <requirement>` starts a new design and adopts nothing; resuming names its plan (`ship-feature docs/plans/<file>.md from <phase>`). Skills state only their expected status and skill-specific transition.

**Never self-approve.** Execution starts at `approved` (or `in-progress` on resume) only after the user's explicit answer at the approval pause; the agent-side prohibition on writing `Status: approved` yourself is CODING `Report, don't decide`.

**Self-check boundary (two enforcement layers):**

| Layer | What | Scope | Proves |
|---|---|---|---|
| `gate-check` (mechanical) | Plan resolution, entry status, the AC budget, `Issue: #<n>`, `Review: READY` before approved execution, registered worktree, proof-commit ordering, ID-graph closure, finalized PR Pattern | Artifact metadata and Git history only — closure proves every ID is *referenced*, never that an edge is *true* | Shape |
| `## Self-Check` (judgment) | Whether ACs express the Goal, meaningful assertions, coverage interpretation, symbol validity, deviations, scope, dependents, output completeness | Prose and evidence | Correctness |
| Approval pause | Explicit human answer to `approval.md`'s question | Consent | Consent |

Do not re-audit in a self-check what the hook already proved, and never treat a hook pass as evidence that the work is correct.

## Phase skills
Load the skill for the current phase via the Skill tool. Each skill loads the single-source files it needs. For the full flow overview, see `skills/dev/README.md`.

| Phase | Skill | Single-source files |
|---|---|---|
| Full cycle (orchestrator) | `dev-ship-feature` | — |
| Frame goal | `dev-frame-goal` | — |
| Design | `dev-design-feature` / `dev-design-system` | `altitude.md`, `dependents.md` |
| Review design | `dev-review-feature` / `dev-review-system` | `independence.md`, `dependents.md` |
| Infra runbook (read-only lane; human executes) | `dev-design-infra` → `dev-review-infra` → `dev-review-infra post` | `independence.md` |
| Approve | (user pause) | `approval.md` |
| Execute | `dev-execute-feature` | `tdd.md`, `coverage.md`, `worktree.md`, `dependents.md` |
| Review code | `dev-review-code` | `independence.md`, `tdd.md`, `coverage.md`, `dependents.md` |
| Publish PR | `dev-create-pr` | `worktree.md` |
| Fix bug | `dev-fix-bug` | `tdd.md`, `coverage.md`, `worktree.md`, `dependents.md` |
| Explore | `dev-explore` | `dependents.md` |
| Create issue | `dev-create-issue` | — |

## Lifecycle
Plan statuses: `planning → approved → in-progress → implemented → reviewed → archived`; `abandoned` = dropped at any non-archived status. Both terminal; `approval.md` owns their semantics and revival re-enters at planning.
