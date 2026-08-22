# /review-feature — Review a Feature Plan

If `~/.dotfiles/.ai-shared/PROCESS.md` is not yet loaded, read it first.

No code, no approval. Challenge the WHAT — the Goal, the AC set, and whether the TC intent lines cover it. TC bodies don't exist yet and aren't yours to judge (`execute-feature` authors them at RED; `review-code` reviews them). Entry: exact `docs/plans/<file>.md`, `Status: planning`. `gate-check` blocks unresolved questions, a missing issue, and **any plan declaring more than 7 ACs**; the Goal/AC/TC/Step graph is yours to verify. An over-cap plan goes back to design-feature to narrow or split the Goal (`design-feature` `AC Budget`).

## Independence and invocation

Follow `independence.md` (single source), including `Re-review`: review is uncounted, and a `NEEDS CHANGES` verdict ends this session once the design fixes are written. Emit `Plan revised. Run the dev-review-feature skill when you want it re-reviewed.` and stop — the next round is the user's to start.

## Review authority

Review reports behavior gaps; it does not silently rewrite the plan. Route findings by state:

- **An existing AC is wrong or ambiguous** → report it; design-feature fixes or drops it.
- **Behavior is missing** — the Goal needs an outcome no AC states:
  - **Before approval:** report it as a missing AC; design-feature adds it through normal iteration. When the plan already holds 7, report the split the missing outcome implies — never an eighth AC, and never an outcome folded into an existing AC to stay under the cap.
  - **After approval:** return through `approval.md`. Use an extension plan only when the outcome is a separate Goal.

**Report only what changes the built artifact.** Everything else — wording preference, stale phrase, rotted citation — goes in one grouped `Nits:` line, is never a finding, and is never a reason for `NEEDS CHANGES`.

## Independent Semantic Review

Avoid anchoring on the proposed tests. Order matters:

1. Read `## Goal`, sources, and contracts. Independently list the observable outcomes and failure conditions the Goal requires — before inspecting the proposed ACs.
2. Compare your list against the proposed ACs. Identify missing, invented, ambiguous, mechanism-coupled, or conflicting criteria, then route findings through design and, when already approved, `approval.md`.
3. Only then inspect the TCs. Two questions: does every **clause** of every AC have a TC whose scenario would necessarily exercise it, and does every `Proves:` name the AC the TC actually constrains? A TC that exercises a clause without quoting its words is covered — block only when a plausible implementation could pass all TCs while violating the clause. Whether a test could pass vacuously is a question for the RED run, not prose argument.
4. **Last** — never before step 3 — read `## Counterexamples Attempted` and `## Review History`. Use them to widen coverage and audit the claims themselves: a recorded defeater is an assertion to verify, not a closed question.

Then attack:

- Can every AC pass while the original Goal fails? (If yes, a missing AC.)
- What invalid implementation would satisfy every AC's Success clause as written? (If one exists, the AC is under-specified — fix the AC, not a TC.)
- What valid implementation would an AC's Failure clause incorrectly condemn?
- Does any AC or TC name a proposed mechanism instead of observable behavior?
- Are relevant negative, boundary, failure, retry, concurrency, and security cases represented?
- Does the plan use shared mutable state (`dependents.md`) as a decision input or signal? If yes: do other flows write it with different semantics? Does a concurrent or sequential write invalidate the decision? Unanalyzed shared state is blocking.
- Does the plan remove a material guard or externally observable behavior without proportionate evidence for why it exists or an explicit accepted uncertainty?

Undefined or unsupported expected behavior → Open Question for the user; never silently choose. A choice only the user can make — a policy, a threshold, a consistency contract — is an Open Question, never an AC defect: do not report it as a finding the designer is expected to resolve alone.

## System and Execution Review

- **Approach:** simplest correct solution; alternatives and assumptions challenged.
- **System fit:** components, contracts, boundaries, compatibility, blast radius, rollback, dependency/deployment order. Compatibility includes credible consumer dependence on errors, defaults, ordering, timing, and side effects beyond documented interfaces.
- **Completeness:** error/failure modes, concurrency, scale, security, observability, edge cases, Non-functional mappings.
- **Traceability:** `gate-check` proves ID closure; you verify edge correctness — every `Proves:` names the right AC, every step satisfies its TCs, every Goal outcome has an AC.
- **Execution:** ordered, right-sized steps; PR slices partition steps, follow dependencies, are independently mergeable, never split a TC.
- **Conditional rigor:** new structures have invariants, guards, and boundary TCs; non-trivial behavior-axis combinations covered or excluded.

## Readiness

`READY` means the behavior is ready for the human's decision, not approved. Leave `Status: planning` — review never approves.

**Two-round cap.** Governs pre-approval design iteration only; a review re-entered after approval (execution rework, `approval.md`) is not bound by a prior cycle's history and starts fresh. If the plan is unapproved and `## Review History` already contains a `NEEDS CHANGES` entry (this is round 2), route every finding, then verdict:

- **Blocking** — a wrong AC, a missing AC, or a structural defect that would lead execution off a cliff. Only these hold `NEEDS CHANGES`.
- **Open Question** — a choice only the user can make, including an unset threshold. Ask it in the report, never in `## Assumptions & Open Questions`: written there it blocks re-entry and routes the plan back through review, which is the third round this cap exists to prevent. Left unanswered it becomes an Open Risk.
- **Open Risk** — everything else: edge-case TC gaps, coverage holes for unlikely scenarios. Into `## Open Risks` for execution to resolve at RED.

No blocking finding → `READY`. Design cannot reach full coverage; execution's RED phase is the second safety net.

On every verdict, append the `## Review History` entry and prune to the last three.

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

- [ ] **Independence and authority:** `independence.md` satisfied, including `Re-review` — this cycle was explicitly invoked, not a continuation of revisions I just made. `## Counterexamples Attempted` and `## Review History` were read only after my own attacks. Review did not silently rewrite behavior. Every reported finding changes the built artifact; wording-only issues are nits and cannot produce `NEEDS CHANGES`.
- [ ] **Behavioral coverage:** outcomes were derived from Goal/sources before TC inspection. Every AC clause is exercised by a TC scenario; a clause gap is blocking only when a plausible implementation could pass all TCs while violating it. Every `Proves:` names the AC its TC constrains. Critical and high-risk ACs faced concrete counterexamples; remaining ACs were checked for invalid-pass and valid-rejection gaps. Plan counterexamples were re-attacked, not accepted.
- [ ] **System fit:** approach is simplest; alternatives challenged; boundaries, compatibility, blast radius, rollback, Non-functional effects sound. Steps are dependency-ordered and right-sized, each names its TCs; PR partition merges independently and splits no TC.

Report summary, independently derived outcomes, blocking findings, the counterexamples **you** attempted, suggestions, and `READY` or `NEEDS CHANGES`.

`NEEDS CHANGES`: clear `Review:`, offer fixes and wait; once the approved revisions are written, stop per `Independence and invocation`. `READY`: leave `Status: planning`, write `Review: READY <ISO date>`, emit: `Plan READY. Run approval.md's spec pause.`
