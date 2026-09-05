# AI — Process

Orchestration rules for plan-backed work (main session only). If `~/.dotfiles/.ai-shared/CODING.md` is not yet loaded, read it first.

## Compliance (non-negotiable)

Apply these within the authority defined in `AGENTS.md`. Correct a violated prerequisite before continuing the affected phase.

1. **Gates block dependent work.** Satisfy a skill's STOP/BLOCKING prerequisite or a `bin/gate-check` block before continuing the affected phase. Fix artifact or verification defects within existing authorization; wait when the prerequisite requires a human decision. Continue independent authorized work. Do not bypass a gate by rephrasing an invocation or treating inferred intent as approval.

2. **Self-checks gate the completion signal.** Run a skill's `## Self-Check` against the artifacts actually produced — not against intent — before emitting its exit line (the phase's closing message; not the `handoff` skill's session snapshot). Unchecked box → fix, re-check; emit only when all pass.

3. **RED before GREEN.** No feature/fix implementation before a failing `test(red): <scope>` commit exists. That commit is tests-only (+ throwing stubs, zero implementation). Refactors require a passing `test: baseline <scope>` commit before changes. If the required test commit doesn't exist for the current slice → write the test/baseline, commit it, then proceed.

4. **Record changes of means.** A deviation changes a specified implementation detail while preserving approved behavior and scope. Before implementing it, log in `## Deviations`: Plan said / Doing instead / Why / Tradeoff. Continue when evidence shows the change preserves contracts, architecture boundaries, verification obligations, and authorized risk. A moved private helper or equivalent internal API replacement alone does not require approval. Pause for a material change to dependencies, cost, security, data integrity, external effects, or reversibility, and present the decision for approval. Spec amendments follow `approval.md`; new scope follows #6. Resolve uncertain behavioral impact before proceeding with the affected change.

5. **Coverage gates are numeric — the number is a floor, not a score.** Coverage proves exercise, not correctness. Can't assert meaningfully → log a Coverage Gap; never write a test to raise the number (CODING `Report, don't decide`; smells: coverage.md `Quality bar`).

   **Bands.** Gate the lines *this change* touched, never the repo-global number: ≥90% → ✅ · 80–89% → ⚠️ log and **continue** · <80% → ❌ STOP and ask.

   **Stricter-only.** A reason can only move the verdict down, never up. Every ⚠️/❌ names *which* lines are uncovered and *which behavior* each belongs to. An uncovered critical path (auth / money / rollback / data-integrity) is ❌ even at ≥90%.

   **Carry, don't close.** A ⚠️ is logged and carried — never Discovered Scope, never a STOP. Closing a gap goes through behavior, never lines; a missing TC can surface as PROCESS #6 work only when closing a ❌ or chosen ⚠️.

   Mechanics — branch-vs-line, patch granularity, denominator curation, the mock caveat — live in `~/.dotfiles/.ai-shared/skills/dev/coverage.md` (single source for measurement; PROCESS owns the gates so coverage can't relax them).

6. **New scope needs a decision.** Log work beyond the plan in `## Discovered Scope` with estimated effort. Ask: include / separate / skip. Do not implement it before authorization. Continue the approved work if it is independent; pause work that depends on the unresolved scope.

7. **Open Questions are a hard gate.** If a plan's `## Assumptions & Open Questions` → `Open Questions:` field contains any real unresolved item, the plan is NOT ready for review. Empty markers such as `none` or `n/a` are allowed; placeholders or bullets are not. If a review finds unresolved Open Questions → verdict is NEEDS CHANGES, route back to design. Never proceed past an open question.

8. **No skipped phases for plan-backed work.** The mandatory chain is: **design-feature → review-feature → spec approval → execute → review-code → PR.** These six cannot be skipped or reordered. `explore` is an optional precursor, not a gate. `frame-goal` precedes the chain on every fresh requirement — collapsing to a pass-through when the requirement is already one clear goal — and hands each confirmed goal to its design lane. Entry-point utilities (`explore`, `create-issue`, `fix-bug diagnose`) never touch application code; every path that mutates application code runs through an approved plan. There is no planless-mutation lane — behavior-preserving cleanup is a `Type: refactor` plan like any other change.

9. **Application behavior is the human's call.** Feature/fix/refactor plans preserve `## Goal` and trace `Goal → AC ↔ TC ↔ Step`. Design and review may propose or refine behavior; only the user approves the concrete spec through `~/.dotfiles/.ai-shared/skills/dev/approval.md`, the single source for the prompt and revision procedure. Other files may name this gate but do not redefine it. Review-feature is self-correction before approval, not a mechanically enforced gate; `gate-check` requires `Status: approved` for execution. A valid approval remains valid on resume and after meaning-preserving editorial corrections. Semantic spec amendments return through review and approval; changes of means follow #4.

## Conventions
**Git credentials.** All git/GitHub actions run under the credential already configured in this environment: the token stored by `gh auth login` for GitHub operations, and `git config user.name`/`user.email` wherever an author is required. Read the identity from there — never assume, invent, or hardcode one. Route GitHub ops through `gh` and rely on its stored credential; never hardcode a token, inject `GITHUB_TOKEN`/`GH_TOKEN`, or switch to a different account than the one already active. `gh auth status` showing no authenticated account, or an author being required with `user.name` unset → STOP, report, wait.

**Base branch (`<base>`):** plan-bound skills read `<base>` from the plan header's `Base:` field — design-feature resolves it to a user-confirmed concrete branch name before handoff. For read-only diagnosis without a plan, resolve the remote default first, then an existing `main`. Keep the full ref so slash-containing branch names and remote-only branches work:

```sh
resolve_diagnostic_base() {
    diagnostic_default=$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null) || diagnostic_default=
    for diagnostic_ref in "$diagnostic_default" refs/heads/main refs/remotes/origin/main; do
        [ -n "$diagnostic_ref" ] || continue
        if git rev-parse --verify --quiet "${diagnostic_ref}^{commit}" >/dev/null; then
            printf '%s\n' "$diagnostic_ref"
            return 0
        fi
    done
    printf '%s\n' 'Cannot resolve a diagnostic base; provide an existing branch or commit.' >&2
    return 1
}
BASE=$(resolve_diagnostic_base)
```

On failure, stop the comparison and ask for its base; never pass an empty value to Git. This read-only fallback does not choose a plan's `Base:`.

**Plan worktree (`<worktree>`):** every plan gets one git worktree at `~/work/ai-worktrees/<repo-basename>-<slug>`, created by execute-feature/fix-bug and reused by every later skill (review-code, create-pr) until create-pr removes it. Once it exists, the worktree copy of the plan is the plan's **single source of truth**: read `Status:` and every section from it, and make every plan edit (status flips, PR-Pattern finalization, Deviations) inside `<worktree>`. The plan file is **never committed** — it stays untracked in both `$MAIN_ROOT` and `<worktree>` throughout the lifecycle; at cleanup, create-pr posts the plan content as an issue comment and removes the local files. All git/gh commands for the plan run there (`cd <worktree>` or `git -C <worktree>`), never in the main working tree. Everything else is `~/.dotfiles/.ai-shared/skills/dev/worktree.md` (single source): resolution from the `$MAIN_ROOT` locator, create, plan copy, dependency symlinks, resume/ancestry checks, `$MAIN_ROOT` sharing, teardown.

**Named plan and entry gates.** Governance binds to a named artifact: every plan-consuming skill takes an exact `docs/plans/<file>.md`. No slug matching, session pin, or silent adoption of the active plan — a dormant plan can never capture unrelated work, and no gate fires merely because a plan exists. Unnamed → STOP and ask for the path. A plan is *active* while its `Status:` is neither of the terminal two, `archived` and `abandoned`; terminal plans are inert and are not entry statuses. `ship-feature <requirement>` starts a new design and adopts nothing; resuming names its plan (`ship-feature docs/plans/<file>.md from <phase>`). Skills state only their expected status and skill-specific transition.

**Never self-approve.** Record `Status: approved` only after the user's approval under `approval.md`. Execution starts at `approved` (or `in-progress` on resume); a status field alone is not evidence of consent.

**Self-check boundary:**

| Layer | What | Scope | Proves |
|---|---|---|---|
| `gate-check` (mechanical) | Plan resolution, entry status, the AC budget, `Issue: #<n>`, `Base:` before execution, registered worktree, proof-commit ordering, ID-graph closure, finalized PR Pattern | Artifact metadata and Git history only — closure proves every ID is *referenced*, never that an edge is *true* | Shape |
| `## Self-Check` (judgment) | Whether ACs express the Goal, meaningful assertions, coverage interpretation, symbol validity, deviations, scope, dependents, output completeness | Prose and evidence | Correctness |
| Approval pause | Explicit human answer to `approval.md`'s question | Consent | Consent |

Do not re-audit in a self-check what the hook already proved, and never treat a hook pass as evidence that the work is correct.

## Phase skills
Load the current phase skill using the platform's skill mechanism. If no dedicated skill tool exists, read its `SKILL.md` through the available file or resource reader. Each skill loads the single-source files it needs. For the full flow overview, see `skills/dev/README.md`.

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
