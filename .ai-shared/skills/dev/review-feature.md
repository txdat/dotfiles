# /review-feature — Review a Feature Plan

No code and no approval decisions. Design remains open: independently challenge the WHAT and HOW rather than ratifying fields. Resolve the active plan per CORE; entry status is `planning`. `gate-check` blocks entry on unresolved Open Questions; the Goal/AC/TC/Step graph is yours to verify, not a parser's.

## Independence

Follow `independence.md` (single source): reviewer `feature-planner`, artifact the plan file, verdict `READY` / `NEEDS CHANGES`.

## Independent Semantic Review

Avoid anchoring on the proposed tests:

1. Read `## Goal`, relevant user/domain sources, and existing contracts first.
2. Before inspecting proposed TCs, independently list the observable outcomes and failure conditions required by the Goal.
3. Compare that list with the proposed ACs. Identify missing, invented, ambiguous, mechanism-coupled, or conflicting criteria.
4. Only then inspect TCs and search adversarially for counterexamples.

Challenge every AC/TC graph with:

- Can every TC pass while its AC fails?
- Which production entry point does each TC's When invoke — does the behavior it proves execute as a consequence, or does the TC join below it?
- Can every AC pass while the original Goal fails?
- What invalid implementation could satisfy the proposed Then assertions?
- What valid implementation would the tests incorrectly reject?
- Is each expected result sourced, or merely repeated from the planner's assumption?
- Are relevant negative, boundary, failure, retry, concurrency, security, and partial-result cases represented?
- Does any test assert a proposed mechanism instead of observable behavior?

Undefined or unsupported expected behavior is blocking and becomes an Open Question for the user. Use concrete competing examples when asking; never silently choose a product/domain outcome.

## System and Execution Review

- **Approach:** simplest correct solution; alternatives and assumptions challenged.
- **System fit:** components, contracts, boundaries, compatibility, blast radius, rollback, and dependency/deployment order inspected.
- **Completeness:** error/failure modes, concurrency, scale, security, observability, edge cases, and Non-functional mappings.
- **Traceability:** every Goal outcome has an AC; every AC has ≥1 TC; every TC has exactly one `Proves: AC-N` and an explicit step reference; every step names ≥1 TC. Nothing mechanical checks this — read it.
- **Execution:** ordered steps; PR slices partition steps, follow dependencies, are independently mergeable, and never split a TC.
- **Altitude:** apply `altitude.md`. A violation is blocking.
- **TDD:** feature/fix scenarios fail first for absent/wrong behavior; refactor scenarios pin passing behavior; assertions do not mirror implementation.
- **Conditional rigor:** new structures have invariants, guards, and boundary TCs; non-trivial behavior-axis combinations are covered or excluded with reason.

## Readiness

`READY` means the behavior is ready for the human's decision, not approved. Leave `Status: planning` — review never approves. The spec pause in `approval.md` follows, driven by ship-feature or by the user directly.

On `READY`, the **main agent** records the verdict in the plan header: `Review: READY <ISO date>`. That marker is what makes the plan eligible for the approval pause and, downstream, for execution — `gate-check` refuses an `approved` plan without it. Only ever write it after an actual review reported READY; a delegated reviewer never writes it. On `NEEDS CHANGES`, clear `Review:`.

## Self-Check (BLOCKING)

- [ ] **Independence:** `independence.md` satisfied — fresh agent, or a session that did not draft; any in-session fallback re-derived every judgment from the plan file and source. Context: __.
- [ ] **Mode/questions:** eligibility or full schema verified; no Open Questions surfaced. Issues: __.
- [ ] **Independent outcomes:** expected outcomes were derived from Goal/sources before TC inspection; missing/invented ACs resolved. Issues: __.
- [ ] **Adversarial behavior:** every AC/TC faced counterexample, invalid-pass, and valid-rejection challenges; failure/edge axes are sufficient. Gaps: __.
- [ ] **Approach/system fit:** alternatives, boundaries, compatibility, order, blast radius, rollback, and Non-functional effects are sound. Issues: __.
- [ ] **Traceability/TDD:** Goal → AC ↔ TC ↔ Step graph, fail/pass intent, meaningful observable assertions, and affected tests hold; each TC's entry point actually executes the behavior it proves. Gaps: __.
- [ ] **Execution shape:** steps are dependency-ordered, ≤10, and each names its TC; the PR partition is independently mergeable and splits no TC; `altitude.md` holds. Issues: __.

Report summary, independently derived outcomes, blocking findings, counterexamples attempted, suggestions, and `READY` or `NEEDS CHANGES`.

`NEEDS CHANGES`: clear `Review:`, offer plan fixes, and wait; design rethink routes to design-feature. `READY`: leave `Status: planning`, write `Review: READY <ISO date>`, and print: `Plan READY. Run approval.md's spec pause — approval is the user's, not mine.`
