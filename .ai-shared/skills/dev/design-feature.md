# /design-feature — Plan a Feature, Fix, or Refactor

If `~/.dotfiles/.ai-shared/PROCESS.md` is not yet loaded, read it first.

**Gates before design:** active plan? → warn. Unfamiliar area? → suggest explore. Bundled/ambiguous goal? → frame-goal first. System-boundary scope? → design-system first. Read AI project configuration. Heavy analysis may delegate to `feature-planner`; the main agent owns the plan and approval. **No code, no approval decisions.** Design-feature proposes behavior; `approval.md` decides it.

Write `docs/plans/<basename>_<date>_<type>_<slug>.md`, where type is feature/fix/refactor.

## Size the plan to the change

**The plan is as short as the change is small.** Keep the core traceability sections below; omit conditional sections rather than padding them.

```text
# Task: <name>
Status: planning | Type: feature|fix|refactor | Issue: #N | Review: | Worktree:
## Goal
## Requirement
## Scope (In / Out)
## Assumptions & Open Questions
## Acceptance Criteria
## Test Cases (intent)        # each names exactly one AC
## Counterexamples Attempted
## Affected Existing Tests
## Open Risks                 # gaps deferred to execution; empty on first draft
## Implementation Steps       # dependency-ordered; each names its TCs
## PR Pattern (provisional)   # single branch unless forced to chain
```

No review carries a round counter: every review cycle is explicitly invoked instead (`independence.md` `Re-review`), and `## Review History` is the durable record of what each verdict attacked.

Add `Context`, `Impact Analysis`, `Design Decisions`, `Mechanism Invariants`, `Risk Flags`, and `Out of Scope` only when the change demands them.

Conditional sections stay compact:

- `Context` — current behavior, dependencies, or ordering that changes the design. When the change relies on, removes, or bypasses existing behavior, include the constraint, incident, compatibility need, or invariant that produced it when discoverable.
- `Impact Analysis` — only affected components, data, or non-functional behavior; contract impact includes credible consumer dependencies on errors, defaults, ordering, timing, and side effects beyond documented interfaces.
- `Design Decisions` — only a choice the executor must preserve.
- `Mechanism Invariants` — only for a new structure.
- `Risk Flags` / `Out of Scope` — only material risks or tempting adjacent work.

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

**A clause** is one separable condition of an AC — a conjunct in Success, or a distinct failure mode. Clauses are what TC coverage is counted against. A TC line carries enough to check that its clause is covered and its `Proves:` is routed correctly; its Given/When/Then is authored at RED, because arrangement-level defects are only detectable by running it.

Filled:

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

## Goal → AC Derivation

1. Preserve the user's original outcome in `## Goal`.
2. Decompose into atomic observable outcomes, constraints, prohibited outcomes, and failure behavior. Each becomes one AC, sourced and implementation-independent. Subjective terms (`fast`, `safe`) → replace with observable measures or ask.
3. **Goal-completeness check.** Can all ACs pass while the Goal still fails? If yes, an outcome is missing — add an AC.
4. Derive TC intent lines only after the AC set is complete. Each TC names exactly one `Proves: AC-N`. An AC whose Success/Failure cannot be judged without reading a TC is under-specified: fix the AC. Cover each AC's happy-path, failure paths, and boundary conditions — one TC per AC is almost never enough. Thin coverage that technically passes clause-audit while leaving obvious scenarios untested is a design defect.
5. **Clause-coverage audit.** Before handoff, enumerate each AC's clauses (the separable conditions in its Success and Failure) and confirm each clause is exercised by at least one TC's scenario — the scenario described would necessarily exercise it, not that the TC quotes the clause's words. A clause with no exercising TC is a gap: add a TC or widen an existing one. This is the last step before the self-check.

## AC Budget

**≤3 clauses per AC.** Derive ACs from the Goal — no more and no less than what the Goal needs. `gate-check` enforces the upper cap at review entry; if it blocks, narrow the Goal or split it into separate plans (`frame-goal`), never merge outcomes into one AC.

Before approval, missing ACs found in review return through design as ordinary iteration. After approval, any behavior change—add, update, or remove—follows `approval.md`. Split an extension plan only when the outcome is independently valuable or would make the current Goal incoherent.

## Counterexamples

Attempt an adversarial implementation against every AC: "Can an implementation pass all proposed TCs while violating this AC or the Goal?" Record each with what defeated it — the AC or TC that constrains the cheat. An attempt nothing defeats is a missing TC.

```text
Target: AC-2 / TC-4
Attempt: reject any refund whose amount ≠ capture amount — passes TC-4 without a balance
         check, so a second partial refund double-spends.
Defeated by: TC-5 (two sequential 30.00 refunds against a 50.00 capture; second must reject).
```

An entry naming no implementation is not an entry. Keep only live rows: a row invalidated by a design change is deleted.

## PR Pattern

**Default: one deployable unit → single branch `<type>/<slug>`.** Chain only when migrations must precede code or slices are independently deployable:

```text
Type: chain
| # | Branch          | Parent          | Steps | Summary            |
|---|-----------------|-----------------|-------|--------------------|
| 1 | feat/quota-db   | main            | 1-2   | migration          |
| 2 | feat/quota-api  | feat/quota-db   | 3-5   | enforcement + API  |
```

Every row carries its own `Parent` — `execute-feature` and `create-pr` read this column and nothing else.

**Every slice is atomic:** one coherent change that is reviewable, mergeable, and revertable on its own, and whose branch tip is **green by itself** — lint, build, and that slice's tests pass at its own tip, against its own parent, with no later slice merged. This is why a TC is never split across slices: the test and the code that makes it pass must land together. A slice whose tests only pass once a later slice merges is not a slice; fold it into the one it depends on, or move the dependency earlier. Atomicity is cohesion, not size — a large migration can be one atomic slice, and three unrelated small fixes are not.

## Planning Rules

- **Design altitude:** follow `altitude.md`. The plan is language-neutral design notation.
- **Cite stable symbols for design instructions.** Use `file:line` only when quoting source as evidence, per `altitude.md`.
- Feature/fix TCs name initially failing observable behavior; refactor TCs name behavior that passes before and after. Tests must not mirror the proposed implementation.
- Derive Affected Components from exploration. Map code-requiring Non-functional commitments to steps or mark `ops-only`.
- For every affected component, dependency, and contract, ask *what happens when this fails*. New/changed failure behavior → failure AC/TC; accepted risk → Risk Flag; no credible answer → Open Question.
- Before removing an existing guard or externally observable behavior, investigate why it exists in proportion to its compatibility, safety, and data-integrity risk. If a material rationale remains unknown, record the uncertainty and preserve the behavior unless the user accepts the risk.
- A new structure requires its operational invariant, initialization/identity guard, and boundary TC.
- For orthogonal behavior axes, cover combinations that change observable behavior; do not enumerate equivalent permutations.

## Issue

**Every plan links exactly one issue.** Creating one is the fallback, not the default: where the requirement, user, or `frame-goal` already named an issue — including a **parent issue** several sibling plans share — link it. Linking happens before handoff.

1. **Resolve the issue:**
   - **None named** → build a body from Goal, Requirement, expected outcome, and Scope; `gh issue create` and record the number.
   - **A dedicated issue named** → fetch it, confirm it is open, update its body where Goal/Requirement/Scope changed.
   - **A parent issue named** → link it. Tracking **several** → leave the body alone: put anything this plan needs to say in a comment. Tracking exactly **one** → enrich the body as above.
2. **Record it.** The header reads exactly `Issue: #<n>`.

A named issue that is closed or belongs to different work → STOP and ask. Credentials: PROCESS `Git credentials`.

## Self-Check (BLOCKING)

- [ ] **Behavior complete:** Goal preserved; all ACs passing does not leave the Goal unfulfilled. Every AC atomic, observable, sourced, pass/fail decidable, implementation-independent. Each AC has happy-path, failure, and boundary TCs. Clause-coverage audit done — each clause exercised by a TC scenario (not literal wording). Every AC faced a counterexample attempt — each names an implementation, its target, and the AC/TC that defeated it; no undefeated attempt stands.
- [ ] **Size:** ACs, clauses, and steps are the coherent set that proves the Goal — no outcome omitted, none inflated. Each AC ≤3 clauses.
- [ ] **Execution sound:** steps are dependency-ordered and each names its TCs. PR Pattern defaults to single, partitions steps when chained, never splits a TC, and gives every slice a tip that can be green with no later slice merged. Affected existing tests are reasoned. Design instructions cite stable symbols; evidence quotes may use `file:line`.
- [ ] **Form correct:** new structures (if any) have guard/invariant/boundary TC; non-trivial behavior-axis combinations covered or excluded; every affected component's failure behavior is answered. Material removed behavior has an evidence-backed reason or an explicit accepted uncertainty, and credible de facto contract changes are explicit. Open Questions empty. Notation, not target-language syntax. Header: `Status: planning`, `Review:` empty on a fresh plan and on re-entry; `Issue: #<n>`.

All checked → emit: `Plan drafted. Run the dev-review-feature skill.`
