# /review-system — Architecture Review

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

Entry: exact `docs/architecture/<file>.md`, `Status: draft`. No latest-document fallback. Read it, relevant source, project config, and the configs that invoke and host the system — scheduler cadence, retry/delivery semantics, concurrency, IAM — these are design surface, not deployment detail. Challenge the decision, not field presence. Review the chain: goal + constraints → options → recommendation → contracts → reversible phases → measured outcome.

## Independence

Follow `independence.md` (single source). The approval pause and any `Status` change stay with the main agent.

## Review

Review all five headings at the depth the change warrants. Treat `Not applicable` as a claim to verify, not a demand to invent content:

- **Outcome (§1):** user goal preserved; pain, constraints, boundaries, target, and baseline/measurement phase are credible. **Attack every success metric:** name a change that hits the target without moving the outcome — if one exists the metric is gameable and needs a paired outcome guard.
- **Options (§2):** alternatives compared honestly, or constraints genuinely eliminate them. Re-attempt both questions: could a simpler option work, and could a simpler working system grow into the target later? Complexity beyond that start must answer a current requirement or evidence, not speculative scale alone. Trade-offs, dependencies, coupling, and critical failure handling are credible.
- **Recommendation (§3):** evidence supports the choice; alternatives represented fairly; contracts cover ownership, compatibility, delivery, and failure semantics without prescribing internals. Challenge credible de facto contracts—errors, defaults, ordering, timing, and side effects—using callers, telemetry, documentation, or history where available, rather than conjecture. Any contract compensating for absent data → prove the data is actually absent: check the API response and codebase's declared-but-unpopulated fields.
- **Migration (§4):** applicable phases are dependency-ordered and independently deployable; every Change/Verify/Rollback gate is workable; destructive steps, synchronization, reconciliation, and cutover are handled honestly.
- **Handoff (§5):** decomposition, when needed, is acyclic and initially actionable; every contract has an owning plan and phase. Verify each contract's observable proof strategy. Production-entry-point tracing belongs to feature/code review once tests exist.

Read `## Review History` only after finishing the review above. Use it to widen coverage and audit the entries themselves — a recorded verdict is a claim to verify, not a settled question. An entry naming a superseded recommendation is history, not evidence: do not re-attack it and do not inherit its conclusions.

Blocking: lost user goal, unmeasurable/gameable success metric, no baseline/measurement phase, decorative alternatives, unjustified present complexity, mechanism for unconfirmed-absent data, undefined or ownerless contract, credible unhandled compatibility break, missing critical failure handling, unverifiable phase, dishonest rollback, dependency cycle. Warnings: oversized phase without checkpoint, unfamiliar technology, operational burden without owner.

## Self-Check (BLOCKING)

- [ ] **Independence, outcome, and options:** `independence.md` satisfied. `## Review History` read only after my own attacks; entries naming a superseded recommendation were not inherited. Goal and measurable outcome hold; each metric attacked for gameability. Simpler option and simpler evolution path were independently challenged; complexity beyond that start has current evidence.
- [ ] **Contracts and migration:** documented contracts and credible de facto dependencies were checked; boundaries and relevant failure semantics are sufficient; critical failures have detection/recovery. Applicable Change/Verify/Rollback gates are credible; omissions are justified rather than padded.
- [ ] **Handoff:** the required plan graph is actionable; contract↔plan↔phase ownership is complete. Every contract has an observable proof strategy for later feature review; architecture review did not require nonexistent test bodies.

Report verdict, blocking findings with required revisions, warnings, and author questions. Omit empty sections and generic praise; note a strength only where it is a decision worth preserving.

On every verdict the main agent appends one entry to `## Review History`; the reviewer reports it and never writes it:

```text
### Review <ISO date> — READY | NEEDS REVISION — reviewing: <recommendation named in §3>
Attacked: <metric gaming, simpler option, or failure mode tried> — <what defeated it, or the finding it produced>
Changed:  <contract, phase, or metric revised in response> | none
```

Naming the recommendation keeps the history usable across designs that outlive their plans. Keep entries to what a future reviewer can act on.

Blocking finding → `NEEDS REVISION`; leave `Status: draft`. Otherwise `READY`, then run `approval.md`'s `## Architecture` pause.
