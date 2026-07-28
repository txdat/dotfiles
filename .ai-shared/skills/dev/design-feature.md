# /design-feature — Plan a Feature, Fix, or Refactor

Warn if another plan is active; unfamiliar area → suggest explore; a requirement that looks bundled or ambiguous at goal level → frame-goal first, before a plan exists to grow around it. Read project config for AI. Heavy analysis may be delegated to `feature-planner`; the main agent owns the plan and the later human approval. Scope that creates or changes a system boundary, communication pattern, service decomposition, or cross-system integration belongs to design-system first. A decomposed plan cites the approved architecture document and phase in Context, preserves the user Goal, and carries assigned contracts as sources, constraints, or invariants whose observable behavior is covered by ACs and TCs. No approval decisions, and no code — neither written to the repo nor embedded in the plan (see Planning Rules).

Write `docs/plans/<basename>_<date>_<type>_<slug>.md`, where type is feature/fix/refactor.

## Plan Schema

Clarify scope, constraints, edge cases, and done in up to three rounds. Keep the plan as short as the change is small — a section with nothing to say is omitted, not padded. Application plans contain:

```text
# Task: <name>
Status: planning | Type: feature|fix|refactor | Issue: | Review: | Rounds: 0 | Worktree:
## Goal                        # preserve the user's requested outcome; do not replace it with TCs
## Requirement                 # problem, why, measurable done
## Context                     # current behavior; dependencies and ordering
## Scope                       # In / Out
## Assumptions & Open Questions
## Impact Analysis
### Affected Components        # file/module/service and change
### API / Contract Changes     # breaking/additive, with details
### Data / Schema              # migration and rollback
### Non-functional             # performance budget, security, observability
## Design Decisions            # decision / options / chosen / reason
## Mechanism Invariants        # conditional; structure / invariant / guard / boundary TC
## Risk Flags                  # risk / mitigation
## Acceptance Criteria         # AC-N observable outcome + Source / Success / Failure
## Test Cases (intent)         # TC-N one-line scenario + Proves — the body is authored in the RED commit
## Counterexamples Attempted   # target AC/TC + the attempt + what defeated it
## Amendments                  # conditional; post-approval AC changes only, numbered, each with the user's sign-off
## Affected Existing Tests     # test + reachability reason + still passes/needs update
## Implementation Steps        # Step N + action + explicit satisfying TC IDs
## Out of Scope                # item + reason
## PR Pattern (provisional)    # type plus branch / parent / steps / summary table
```

Item shape:

```text
AC-1 — <one observable outcome>
  Source: <user goal quote, contract, domain rule, or specification>
  Success: <observable result>
  Failure: <result that violates this AC>

TC-1 — <one scenario, one line, naming the behavior and the condition that distinguishes it>
  Proves: AC-1
  Test: <filled during execution — path::name>
```

**A clause** is one separable condition of an AC — a conjunct in its Success, or a distinct failure mode in its Failure. Write clauses as separable statements: they are what TC coverage is counted against, in review-feature's coverage check and review-code's reachability walk alike.

A TC line carries enough to check two things in review: that the AC clause it names is covered, and that its `Proves:` is routed correctly. Its Given/When/Then is authored as a running test in the RED commit (`execute-feature`), because the defects that live in an arrangement — a test that passes against unmodified code, a fixture that cannot be built — are only detectable by running it.

Filled, for reference — note that `Source` is what kills the vacuous AC, because "the system works correctly" cannot be sourced:

```text
AC-2 — a refund exceeding the remaining refundable balance is rejected without mutating the ledger
  Source: user goal — "we can never refund more than we took"
  Success: the call returns reject(exceeds_refundable_balance) and the ledger balance is unchanged
  Failure: any ledger write occurs, or a partial refund is recorded

TC-4 — a refund above the remaining balance is rejected and writes nothing
  Proves: AC-2
  Test: <filled during execution — path::name>

TC-5 — two sequential partial refunds cannot exceed the balance together
  Proves: AC-2
  Test: <filled during execution — path::name>
```

Two TCs, because AC-2's Success has two clauses (rejected **and** ledger unchanged) and its failure mode has a sequential form. Clause count, not scenario prose, is what the AC-coverage check reads.

Design-feature proposes behavior; it never approves it. `approval.md` (single source) owns that decision.

## Goal → AC Derivation

1. Preserve the user's original outcome in `## Goal`; separate later interpretation under Requirement/Assumptions.
2. Decompose the Goal into atomic actors, triggers, observable outcomes, constraints, prohibited outcomes, failure behavior, and measurable non-functional results.
3. Convert each atomic outcome into one implementation-independent AC. Unsupported expected behavior is an Open Question, never an invented AC.
4. Cite the source for every AC. Replace subjective terms (`fast`, `safe`, `correct`) with observable measures or ask the user.
5. Derive TC **intent lines** only after the AC set is complete. Each TC has exactly one `Proves: AC-N`, and every clause of every AC is named by at least one TC. An AC may own multiple positive, negative, boundary, failure, concurrency, or security scenarios. No Given/When/Then here — the item-shape note above says why. An AC whose Success and Failure cannot be judged without reading a TC is under-specified: fix the AC.
6. Attempt the counterexample: "Can an implementation pass all proposed TCs while violating this AC or the Goal?" If yes, refine ACs/TCs before handoff. Record each attempt in `## Counterexamples Attempted` with **what defeated it** — name the AC or TC that constrains the cheat, not a defect in the plan. An attempt nothing defeats is a missing TC: add it, then log the attempt as defeated by the TC you added. review-feature reads the plan and nothing else, so an attempt you keep in your head is one it cannot re-attack, and a bare "none found" is unfalsifiable.

An entry names the *cheating implementation* you tried, not the fact that you tried:

```text
Target: AC-2 / TC-4
Attempt: reject every refund whose amount differs from the captured amount — passes TC-4
         without comparing against remaining balance, so a second partial refund double-spends.
Defeated by: TC-5 (two sequential 30.00 refunds against a 50.00 capture; the second must reject).
```

"Attempted: tried to cheat. Defeated by: AC-1" is not an entry — it names no implementation and gives review-feature nothing to re-attack.

With TC bodies authored at execution, a defeater here names an **AC clause or a TC intent**, and is therefore an argument, not yet a proof. `review-code` re-attacks each one against the running test and the implementation, which is where a defeater is actually binding. Keep only **live** rows: a row invalidated by a design change is deleted, not annotated — a struck row defends nothing and reads to the next reviewer as coverage.

## Planning Rules

- **Design altitude:** follow `altitude.md` (single source). The plan is language-neutral design notation throughout.
- Leave `Review:` empty — review-feature owns it. Never write `Status: approved` or `Review: READY` here.
- `Rounds:` starts at 0 and is review-feature's counter; design-feature writes the 0 and never touches it again. It **survives a NEEDS CHANGES re-entry** — review history prunes, but the count does not, and resetting it is how a loop hides its own length. Only a decomposition or rethink that produces a *new plan file* starts a new count.
- Open Questions must be empty before handoff; move settled answers into assumptions or their owning section.
- Use dependency-ordered steps, as few as the change needs; >10 → split. Verify symbols named by steps against their target type/module.
- Goal → AC ↔ TC ↔ Step traceability is complete: every AC has ≥1 TC, every TC names exactly one AC and appears by ID in ≥1 step, and every step names ≥1 TC. Enumerate IDs; never write ranges such as `TC-1 through TC-4`.
- Feature/fix TCs name initially failing observable behavior; refactor TCs name behavior that passes before and after. `execute-feature` proves that intent at RED and rejects any TC whose test passes against unmodified code. Tests must not mirror the proposed implementation.
- **AC budget: 8, and ≤3 clauses per AC** — this bullet is the single source for both numbers. Chosen tripwires, sized to what they protect: the approval pause is one human judging the whole contract in one sitting; review's two rounds can attack a ≤24-clause surface clause by clause; and past eight ACs the ≤10-step cap bursts anyway, so the tripwires fire together. Over budget → the Goal is too broad for one plan: STOP and return the requirement through `frame-goal` (single source for the too-broad test and split boundaries), which yields issue-backed goals, dependency-ordered via PR `Parent`, each with its own plan and approval. The clause cap keeps the AC cap honest: fewer, fatter ACs grow the same surface while evading the count.
- **After handoff the AC set only narrows: update, remove, refine — never add.** A new AC is a new outcome, and a new outcome belongs to a new Goal: draft it as its own issue-backed extension plan (parented per the PR Pattern rules, on this plan's branch if unmerged), and let the user decide whether it runs at all. This holds from the moment the plan reaches review — a review round may send back a wrong or ambiguous AC to fix or drop, never a new one to absorb — and an update may not grow an AC's clause count to smuggle the addition in. Missing coverage of an *existing* AC clause is refinement (a TC intent), not a new AC. Post-approval, updates and removals go back through `approval.md` and are recorded as numbered `## Amendments` entries naming what changed, why, and the user's sign-off; pre-approval they are ordinary design iteration and `## Amendments` stays empty.
- **Cite symbols, never line numbers.** `normalizeLb`'s missing-label default survives a commit; `monitoring.ts:293` does not. A rotted citation is a finding a later reviewer must spend a round on and which changes nothing about the built artifact.
- Derive Affected Components from exploration or direct inspection. Answer every impact category; map code-requiring Non-functional commitments to steps or mark `ops-only`.
- For every affected component, external dependency, and contract, ask *what happens when this fails* — down, timeout, crash mid-operation, partial write, retry/duplicate. New or changed failure behavior → failure AC/TC; accepted risk → Risk Flag; no credible answer → Open Question. Existing handling the change doesn't touch needs no artifact.
- Find Affected Existing Tests semantically, then by targeted search. Predict `still passes` or `needs update` with reason; empty only for isolated new code.
- A new structure requires its operational invariant, initialization/identity guard, and boundary TC using the same key after zero/full/exhausted/evicted state.
- For orthogonal behavior axes, cover each non-trivial combination with a TC or justify it under Out of Scope.

## PR Pattern

Draft once the issue exists. One deployable unit → single branch `<type>/<slug>`. Otherwise chain independently mergeable slices, ordered by dependencies; migrations isolate first, shared architecture precedes behavior, and service slices include all their layers. The table partitions every step exactly once and keeps every TC wholly within one slice.

**Every row carries its own `Parent`** — the branch this slice builds on and the PR's base. It is data, never inferred: normally `<base>` for a single PR or slice 1, and the preceding branch for later slices, but a follow-up plan amending an **unmerged** PR names that PR's branch instead (README `Plan statuses`). Both `execute-feature` (worktree `<parent>`) and `create-pr` (`gh pr create --base`) read this column and nothing else, so an unrecorded parent is a plan defect, not something a later phase may guess.

```text
Type: chain
| # | Branch          | Parent          | Steps | Summary            |
|---|-----------------|-----------------|-------|--------------------|
| 1 | feat/quota-db   | main            | 1-2   | migration          |
| 2 | feat/quota-api  | feat/quota-db   | 3-5   | enforcement + API  |
```

Show name, type, requirement, AC/TC/step counts, and path. Ask for design changes. Never ask for spec approval here — that pause belongs to `approval.md`, after review-feature returns READY.

## Issue

Every plan is issue-backed, and design-feature owns creating it — before handoff, not deferred to the execution gate, so the omission surfaces while the plan is still being written rather than after approval:

1. Build the body from `## Goal`, `## Requirement`, the expected outcome, and `## Scope` — enough for someone who never reads the plan.
2. **Create if absent; otherwise reconcile.** `Issue:` empty → `gh issue create`, then record `Issue: #<n>` in the header. `Issue: #<n>` already present (a NEEDS CHANGES round re-entering design, or a deferred-goal issue `frame-goal` created) → do **not** open a second issue: fetch it, confirm it is open and still describes this plan, and update its body where the Goal, Requirement, or Scope changed. A recorded issue that is closed or belongs to different work → STOP and ask; never silently repoint the header. Credentials are CORE `Git credentials`; this skill adds nothing to them.

`create-issue` stays restricted to standalone issues with no plan behind them.

## Self-Check (BLOCKING)

- [ ] **Schema and questions:** every section that applies is filled; Open Questions empty; `Status: planning`; `Review:` empty; `Rounds:` is 0 on a fresh plan and untouched on a re-entry.
- [ ] **Issue:** exactly one issue backs this plan — created if `Issue:` was empty, reconciled (not duplicated) if it was already set; it is open, its body carries Goal, Requirement, expected outcome, and Scope, and the header reads exactly `Issue: #<n>`.
- [ ] **Goal and ACs:** Goal is preserved; each AC is atomic, observable, sourced, pass/fail decidable, and implementation-independent; `## Counterexamples Attempted` names each attempt, its target, and the AC/TC that defeated it — never a bare "none found", never an undefeated attempt left standing.
- [ ] **Approach/impact:** requirement and scope are measurable; components/contracts/data/non-functional effects and decisions are concrete; every affected component, dependency, and contract has its failure behavior answered.
- [ ] **BDD/TDD:** every TC has a one-line intent, one owning AC, and correct fail/pass intent; **every clause of every AC's Success and Failure is named by at least one TC**; Goal → AC ↔ TC ↔ Step mapping is complete; affected existing tests are reasoned. No Given/When/Then is written here.
- [ ] **Budget and narrowing:** the AC set is ≤8 with ≤3 clauses per AC (else the plan was decomposed); on a re-entry from review the AC set did not grow — new outcomes went to extension plans; `## Amendments` is empty pre-approval, and any post-approval entry carries the user's sign-off; plan citations name symbols, not line numbers.
- [ ] **Conditional rigor:** each new structure has guard/invariant/boundary TC; behavior-axis combinations are covered or excluded with reason.
- [ ] **Execution shape:** steps are dependency-ordered, each names the TC it satisfies, and are ≤10 (else split); provisional PR Pattern partitions steps and does not split a TC.
- [ ] **Altitude:** `altitude.md`'s drafting standard was applied — target-language syntax rewritten as notation before handoff. Review-feature treats a violation as only a Should Fix, so this checkbox is where the standard is actually held.

All checked → emit: `Plan drafted. Run the review-feature skill.`
