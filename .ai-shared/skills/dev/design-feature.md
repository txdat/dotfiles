# /design-feature — Plan a Feature, Fix, or Refactor

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

**Gates before design:** active plan? → warn. Unfamiliar area? → suggest explore. Bundled/ambiguous goal? → frame-goal first. System-boundary scope? → design-system first. Read project config for AI. Heavy analysis may delegate to `feature-planner`; the main agent owns the plan and approval. **No code, no approval decisions.** Design-feature proposes behavior; `approval.md` decides it.

Write `docs/plans/<basename>_<date>_<type>_<slug>.md`, where type is feature/fix/refactor.

## Size the plan to the change

**The plan is as short as the change is small.** Keep the core traceability sections below; omit conditional sections rather than padding them.

```text
# Task: <name>
Status: planning | Type: feature|fix|refactor | Issue: #N | Review: | Rounds: 1 | Worktree:
## Goal
## Requirement
## Scope (In / Out)
## Assumptions & Open Questions
## Acceptance Criteria        # fix: 1–2 ACs; feature: 3–5; rarely all 8
## Test Cases (intent)        # one line per TC; each names exactly one AC
## Counterexamples Attempted
## Affected Existing Tests
## Implementation Steps       # dependency-ordered; each names its TCs
## PR Pattern (provisional)   # single branch unless forced to chain
```

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
3. Derive TC intent lines only after the AC set is complete. Each TC names exactly one `Proves: AC-N`; every clause of every AC is named by at least one TC. An AC whose Success/Failure cannot be judged without reading a TC is under-specified: fix the AC.

## AC Budget

**≤8 ACs, ≤3 clauses per AC.** A fix: 1–2 ACs. A feature: 3–5. These are heuristics — approaching them means reconsider whether the Goal is too broad. Split when cohesion suffers, not by rule. Start from the smallest set that proves the Goal and stop.

Before approval, missing ACs found in review return through design as ordinary iteration. After approval, any behavior change—add, update, or remove—follows `approval.md`. Split an extension plan only when the outcome is independently valuable or would make the current Goal incoherent.

## Counterexamples

Attempt at least one adversarial implementation against the most critical AC: "Can an implementation pass all proposed TCs while violating this AC or the Goal?" Record each with what defeated it — the AC or TC that constrains the cheat. An attempt nothing defeats is a missing TC.

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

- [ ] **Behavior complete:** Goal preserved; every AC atomic, observable, sourced, pass/fail decidable, implementation-independent. Every clause of every AC has a TC naming it. Counterexamples are live — each names an implementation, its target, and the AC/TC that defeated it; no undefeated attempt stands.
- [ ] **Size:** AC/clauses and steps are the smallest coherent set that proves the Goal; approaching the heuristics triggered a split check, not automatic decomposition.
- [ ] **Execution sound:** steps are dependency-ordered and each names its TCs. PR Pattern defaults to single, partitions steps when chained, never splits a TC. Affected existing tests are reasoned. Design instructions cite stable symbols; evidence quotes may use `file:line`.
- [ ] **Form correct:** new structures (if any) have guard/invariant/boundary TC; non-trivial behavior-axis combinations covered or excluded; every affected component's failure behavior is answered. Material removed behavior has an evidence-backed reason or an explicit accepted uncertainty, and credible de facto contract changes are explicit. Open Questions empty. Notation, not target-language syntax. Header: `Status: planning`, `Review:` empty, `Rounds: 1` on a fresh plan and preserved on re-entry, `Issue: #<n>`.

All checked → emit: `Plan drafted. Run the review-feature skill.`
