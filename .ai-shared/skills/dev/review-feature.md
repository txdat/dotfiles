# /review-feature — Review a Feature Plan

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

No code and no approval decisions. Independently challenge the WHAT — the Goal, the AC set, and whether the TC intent lines cover it — rather than ratifying fields. You are reviewing a spec, not a transcript: TC bodies do not exist yet and are not yours to write or to judge (`execute-feature` authors them at RED; `review-code` reviews them). Takes an exact `docs/plans/<file>.md` per PROCESS `Named plan and entry gates`; entry status is `planning`. `gate-check` blocks entry on unresolved Open Questions and on a missing `Issue: #<n>`; the Goal/AC/TC/Step graph is yours to verify, not a parser's.

## Independence

Follow `independence.md` (single source).

## Budget and the no-new-behavior rule

Three rules, structural rather than judgment, because judgment always says "one more round" — every round genuinely finds something, which is exactly why an unbounded loop never terminates.

**A behavior finding ends the round; it never lands as an AC.** Review may **never** add, widen, or reinterpret an AC — the AC set only narrows after handoff (`design-feature` `After handoff`). Two cases, and the split matters:

- **An existing AC is wrong or ambiguous** → report it and stop; design-feature fixes or drops it. That is the round-trip the budget below counts.
- **Behavior is missing** — the Goal needs an outcome no AC states → that is a **new Goal, not a finding to absorb**: report it as a proposed extension plan (its own approval, its own issue link — a new issue or the parent this plan already uses, parented per the PR Pattern rules) and leave this plan's AC set alone. Whether the extension runs at all is the user's call. Adding behavior inside a review is how a one-sentence request becomes a fourteen-AC plan: each addition arrives unreviewed and becomes the next round's defect surface.

(Post-approval re-review after an amendment is different ground: the amendment already carries the user's sign-off per `approval.md`, and this review judges the amended subgraph, not the frozen remainder.) **A second wrong-AC round-trip on one plan is a decomposition trigger** — the Goal is being discovered, not reviewed.

**Two rounds, hard gate.** The round number is the plan header's `Rounds:` field, never session memory. Round 1 is the first review; round 2 is the second and final round — verify fixes landed and attack what changed. After round 2: READY or the plan goes back to design-feature for decomposition, never to round 3.

**Report only what changes the built artifact.** A finding is reportable when it changes what gets built or lets a wrong implementation pass. Everything else — a rotted citation, a stale phrase — goes in one grouped `Nits:` line and is **never** a reason to withhold READY.

## Independent Semantic Review

Avoid anchoring on the proposed tests:

1. Read `## Goal`, relevant user/domain sources, and existing contracts first.
2. Before inspecting proposed TCs, independently list the observable outcomes and failure conditions required by the Goal.
3. Compare that list with the proposed ACs. Identify missing, invented, ambiguous, mechanism-coupled, or conflicting criteria — routing per the no-new-behavior rule: wrong/ambiguous round-trips, missing becomes an extension-plan proposal.
4. Only then inspect the TC intent lines. Two questions, and only these two: does every **clause** of every AC (`design-feature` defines the term) have a TC naming it, and does every `Proves:` name the AC the TC actually constrains? A TC's arrangement is not here to be judged; asking whether it could pass vacuously is a question for the RED run, and answering it in prose is how the same vacuous-pass defect gets "fixed" three times. Then search adversarially for counterexamples against the AC set.
5. Last of all — never before step 4 — read `## Counterexamples Attempted` and any `## Review History`. Reading them earlier tells you which areas are already "settled" and is the anchoring this ordering exists to prevent. Use them only to widen coverage and to audit the claims themselves: a recorded defeater is an assertion to verify, not a closed question, and a round that changed ACs/TCs is a place to check the change actually landed.

Challenge every AC/TC graph with:

- Does any AC clause have no TC naming it? (An AC clause no test reaches is the one gap prose review reliably catches — it is absence, which no test run reports.)
- Does any `Proves:` name an AC the TC does not constrain?
- Can every AC pass while the original Goal fails?
- What invalid implementation could satisfy every AC's Success clause as written? (If one exists, the AC is under-specified — the fix is the AC, not a TC.)
- What valid implementation would an AC's Failure clause incorrectly condemn?
- Is each expected result sourced, or merely repeated from the planner's assumption?
- Are relevant negative, boundary, failure, retry, concurrency, security, and partial-result cases represented as clauses or TC intents?
- Does any AC or TC intent name a proposed mechanism instead of observable behavior?

Undefined or unsupported expected behavior is blocking and becomes an Open Question for the user. Use concrete competing examples when asking; never silently choose a product/domain outcome.

## System and Execution Review

- **Approach:** simplest correct solution; alternatives and assumptions challenged.
- **System fit:** components, contracts, boundaries, compatibility, blast radius, rollback, and dependency/deployment order inspected.
- **Completeness:** error/failure modes, concurrency, scale, security, observability, edge cases, and Non-functional mappings.
- **Traceability:** `gate-check` proves the ID graph is *closed* — every AC has a TC, every TC one `Proves:` and a step, every step a TC. Closure is not correctness: it cannot tell whether a `Proves:` names the **right** AC, whether a step actually satisfies the TC it cites, or whether every Goal outcome has an AC at all. Verify every edge, not the graph — a plan where every ID is referenced and every mapping is wrong passes the hook.
- **Execution:** ordered steps; PR slices partition steps, follow dependencies, are independently mergeable, and never split a TC.
- **Altitude:** apply `altitude.md`. A violation is a Should Fix finding reported with its rewrite — never blocking, and never a reason to clear `Review:`.
- **TDD:** feature/fix intents name behavior that must fail first for absence; refactor intents pin behavior that passes before and after. Whether a test actually fails first, and whether its assertions mirror the implementation, are settled at RED and review-code — not argued here.
- **Conditional rigor:** new structures have invariants, guards, and boundary TCs; non-trivial behavior-axis combinations are covered or excluded with reason.

## Readiness

`READY` means the behavior is ready for the human's decision, not approved. Leave `Status: planning` — review never approves. The spec pause in `approval.md` follows, driven by ship-feature or by the user directly.

On **every** verdict, READY or NEEDS CHANGES, the main agent increments the header's `Rounds:` field — the durable record — appends one entry to `## Review History`, and prunes to the last entry. A round that mattered changed the AC set, and the change survives; what pruning discards is the argument, which is the surface a later round re-litigates. Two rounds is the hard cap:

```text
### Review <ISO date> — READY | NEEDS CHANGES
Attacked: <counterexample tried> — <what defeated it, or the finding it produced>
Changed:  <AC IDs revised or dropped; TC IDs added, revised, or dropped; extension plans proposed> | none
```

Filled:

```text
### Review 2026-03-14 — NEEDS CHANGES
Attacked: satisfy TC-4 by rejecting any refund ≠ capture amount — passes without a balance
          check, so two partial refunds double-spend. Nothing in the plan defeated it.
Changed:  added TC-5 (sequential partial refunds); revised AC-2 to name remaining balance
          rather than captured amount.
```

"Reviewed — READY" is not an entry: it records no attack, so the next reviewer inherits nothing. Keep it to what a future reviewer can act on; findings that changed nothing are noise, and git history already holds the diff. The reviewer reports these; only the main agent writes them.

On `READY`, the **main agent** records the verdict in the plan header: `Review: READY <ISO date>`. That marker is what makes the plan eligible for the approval pause and, downstream, for execution — `gate-check` refuses an `approved` plan without it. Only ever write it after an actual review reported READY; a delegated reviewer never writes it. On `NEEDS CHANGES`, clear `Review:`.

## Self-Check (BLOCKING)

- [ ] **Independence:** `independence.md` satisfied — fresh agent, or a session that did not draft; any in-session fallback re-derived every judgment from the plan file and source; `## Counterexamples Attempted` and `## Review History` were read only after my own attacks. Context: __.
- [ ] **Mode/questions:** eligibility or full schema verified; no Open Questions surfaced. Issues: __.
- [ ] **Independent outcomes:** expected outcomes were derived from Goal/sources before TC inspection; missing/invented ACs resolved. Issues: __.
- [ ] **Adversarial behavior:** every AC faced counterexample, invalid-pass, and valid-rejection challenges, each attempt named with what defeated it rather than asserted as clean; `## Counterexamples Attempted` was re-attacked rather than accepted — verify each claimed defeater really constrains the cheat, and treat a thin, absent, or self-defeating entry as a finding; failure/edge axes are sufficient. Gaps: __.
- [ ] **Budget and boundary:** the round number came from the header's `Rounds:` field, not memory, and the field was incremented with this verdict; hard gate at 2 rounds — entry at `Rounds: 2` is the final round, and a blocker here ends the lane (decomposition, never round 3); no finding of mine added, widened, or reinterpreted an AC — wrong-AC findings ended the round and routed to design, and missing behavior was proposed as an extension plan, never absorbed; every reported finding changes what gets built or admits a wrong implementation, and the rest are one grouped `Nits:` line. `Rounds:` now: __.
- [ ] **Approach/system fit:** alternatives, boundaries, compatibility, order, blast radius, rollback, and Non-functional effects are sound. Issues: __.
- [ ] **Traceability/coverage:** Goal → AC ↔ TC ↔ Step graph holds edge by edge; every AC clause has a TC naming it; every `Proves:` names the AC its TC constrains; fail/pass intent is right per axis; affected existing tests are reasoned. Gaps: __.
- [ ] **Execution shape:** steps are dependency-ordered, ≤10, and each names its TC; the PR partition is independently mergeable and splits no TC. Issues: __.

Report summary, independently derived outcomes, blocking findings, the counterexamples **you** attempted (distinct from the plan's `## Counterexamples Attempted`, which you are judging), suggestions, and `READY` or `NEEDS CHANGES`.

`NEEDS CHANGES`: clear `Review:`, offer plan fixes, and wait; design rethink routes to design-feature. `READY`: leave `Status: planning`, write `Review: READY <ISO date>`, and emit: `Plan READY. Run approval.md's spec pause — approval is the user's, not mine.`
