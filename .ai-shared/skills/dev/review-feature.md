# /review-feature — Review a Feature Plan

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

No code, no approval. Challenge the WHAT — the Goal, the AC set, and whether the TC intent lines cover it. TC bodies don't exist yet and aren't yours to judge (`execute-feature` authors them at RED; `review-code` reviews them). Entry: exact `docs/plans/<file>.md`, `Status: planning`, and `Rounds:` 1 or 2. `gate-check` blocks unresolved questions, a missing issue, and any third review; the Goal/AC/TC/Step graph is yours to verify.

## Independence

Follow `independence.md` (single source).

## Review authority

Review reports behavior gaps; it does not silently rewrite the plan. Route findings by state:

- **An existing AC is wrong or ambiguous** → report it; design-feature fixes or drops it. This counts as a round.
- **Behavior is missing** — the Goal needs an outcome no AC states:
  - **Before approval:** report it as a missing AC; design-feature adds it through normal iteration. This counts as a round.
  - **After approval:** return through `approval.md`. Use an extension plan only when the outcome is a separate Goal.

`Rounds:` starts at 1 and identifies the attempt being run. **Two attempts maximum.** `gate-check` admits exactly 1 or 2 and rejects exhausted, missing, malformed, non-canonical, or duplicate values. Increment once after every verdict. A second-attempt `NEEDS CHANGES` advances the counter to 3 and ends this plan's lane. Never reset the counter; the user must choose replacement, decomposition into new plans, or abandonment.

**Report only what changes the built artifact.** Everything else — stale phrase, rotted citation — goes in one grouped `Nits:` line and is never a reason to withhold READY.

## Independent Semantic Review

Avoid anchoring on the proposed tests. Order matters:

1. Read `## Goal`, sources, and contracts. Independently list the observable outcomes and failure conditions the Goal requires — before inspecting the proposed ACs.
2. Compare your list against the proposed ACs. Identify missing, invented, ambiguous, mechanism-coupled, or conflicting criteria, then route findings through design and, when already approved, `approval.md`.
3. Only then inspect the TCs. Two questions: does every **clause** of every AC have a TC naming it, and does every `Proves:` name the AC the TC actually constrains? Whether a test could pass vacuously is a question for the RED run, not prose argument.
4. **Last** — never before step 3 — read `## Counterexamples Attempted` and `## Review History`. Use them to widen coverage and audit the claims themselves: a recorded defeater is an assertion to verify, not a closed question.

Then attack:

- Can every AC pass while the original Goal fails? (If yes, a missing AC.)
- What invalid implementation would satisfy every AC's Success clause as written? (If one exists, the AC is under-specified — fix the AC, not a TC.)
- What valid implementation would an AC's Failure clause incorrectly condemn?
- Does any AC or TC name a proposed mechanism instead of observable behavior?
- Are relevant negative, boundary, failure, retry, concurrency, and security cases represented?
- Does the plan remove a material guard or externally observable behavior without proportionate evidence for why it exists or an explicit accepted uncertainty?

Undefined or unsupported expected behavior → Open Question for the user; never silently choose.

## System and Execution Review

- **Approach:** simplest correct solution; alternatives and assumptions challenged.
- **System fit:** components, contracts, boundaries, compatibility, blast radius, rollback, dependency/deployment order. Compatibility includes credible consumer dependence on errors, defaults, ordering, timing, and side effects beyond documented interfaces.
- **Completeness:** error/failure modes, concurrency, scale, security, observability, edge cases, Non-functional mappings.
- **Traceability:** `gate-check` proves ID closure; you verify edge correctness — every `Proves:` names the right AC, every step satisfies its TCs, every Goal outcome has an AC.
- **Execution:** ordered, right-sized steps; PR slices partition steps, follow dependencies, are independently mergeable, never split a TC.
- **Conditional rigor:** new structures have invariants, guards, and boundary TCs; non-trivial behavior-axis combinations covered or excluded.

## Readiness

`READY` means the behavior is ready for the human's decision, not approved. Leave `Status: planning` — review never approves.

On every verdict, append the `## Review History` entry, prune to the last entry, then increment `Rounds:` exactly once. A READY verdict proceeds normally. A round-2 `NEEDS CHANGES` leaves `Rounds: 3` and ends this plan's review lane as described above.

```text
### Review <ISO date> — READY | NEEDS CHANGES
Attacked: <counterexample tried> — <what defeated it, or the finding it produced>
Changed:  <AC/TC IDs added, revised, or dropped; extension plans proposed> | none
```

Filled:

```text
### Review 2026-03-14 — NEEDS CHANGES
Attacked: satisfy TC-4 by rejecting any refund ≠ capture amount — passes without a balance
          check, so two partial refunds double-spend. Nothing in the plan defeated it.
Changed:  added TC-5 (sequential partial refunds); revised AC-2 to name remaining balance.
```

"Reviewed — READY" is not an entry: it records no attack. The reviewer reports findings; only the main agent writes the history entry and, on `READY`, sets `Review: READY <ISO date>` in the header. On `NEEDS CHANGES`, clear `Review:`.

## Self-Check (BLOCKING)

- [ ] **Independence, authority, and rounds:** `independence.md` satisfied. Entry `Rounds:` was 1 or 2, and the verdict was recorded before incrementing it exactly once. `## Counterexamples Attempted` and `## Review History` were read only after my own attacks. Review did not silently rewrite behavior. Every reported finding changes the artifact; the rest are one `Nits:` line.
- [ ] **Behavioral coverage:** outcomes were derived from Goal/sources before TC inspection. Every AC clause has a TC naming it. Every `Proves:` names the AC its TC constrains. Critical and high-risk ACs faced concrete counterexamples; remaining ACs were checked for invalid-pass and valid-rejection gaps. Plan counterexamples were re-attacked, not accepted.
- [ ] **System fit:** approach is simplest; alternatives challenged; boundaries, compatibility, blast radius, rollback, Non-functional effects sound. Steps are dependency-ordered and right-sized, each names its TCs; PR partition merges independently and splits no TC.

Report summary, independently derived outcomes, blocking findings, the counterexamples **you** attempted, suggestions, and `READY` or `NEEDS CHANGES`.

`NEEDS CHANGES`: clear `Review:`. After attempt 1, offer fixes and wait; after attempt 2, stop and offer replacement, decomposition, or abandonment. `READY`: leave `Status: planning`, write `Review: READY <ISO date>`, emit: `Plan READY. Run approval.md's spec pause.`
