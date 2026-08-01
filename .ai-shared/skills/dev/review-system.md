# /review-system — Architecture Review

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

Takes an exact `docs/architecture/<file>.md` in `$ARGUMENTS`, and it must be `Status: draft` — there is no latest-document fallback, for the reason PROCESS `Named plan and entry gates` gives for plans. Unlike the plan lane, **nothing mechanical enforces this**: `gate-check` treats the architecture skills as ungated entry skills and never resolves or validates an architecture document, so the named path and the `draft` status are this skill's own check. Not given an exact path, or the document is not `draft` → STOP and ask. Read it, relevant source, project config for AI, and the configs that invoke and host the system — scheduler cadence and jitter, retry and delivery semantics, concurrency, IAM — which are design surface, not deployment detail. Independently challenge the decision, not field presence. Review the chain: goal and constraints → options → recommendation → contracts → reversible phases → measured outcome.

## Independence

Follow `independence.md` (single source). The approval prompt, its pause, and any `Status` change stay with the main agent.

## Review

- **Outcome:** the user goal is preserved; pain, constraints, boundaries, target, and baseline or measurement phase are credible. Attack every success metric: name a change that hits the target without moving the outcome — if one exists the metric is gameable and needs a paired outcome guard or a second measurement.
- **Options:** viable alternatives were compared, or hard constraints genuinely eliminate them; trade-offs, dependencies, coupling, and critical failure handling are credible. Re-attempt the simpler-option counterexample.
- **Recommendation:** evidence supports the choice; alternatives are represented fairly; contracts cover ownership, compatibility, delivery, and failure semantics without prescribing unnecessary internals. Any contract compensating for absent data → prove the data is actually absent: check the API's response and the codebase's own declared-but-unpopulated fields.
- **Migration:** phases are dependency-ordered and independently deployable; every Change/Verify/Rollback gate is workable; destructive steps, synchronization, reconciliation, and cutover are handled honestly.
- **Handoff:** decomposition is acyclic and initially actionable; every contract has an owning plan and phase; observable contract behavior reaches AC/TC proof while feature Goals remain user outcomes. For each contract, name the production entry point its AC/TC invokes — a proof that joins below the behavior it governs proves nothing; trace the real path (stub → adapter → parser → detector → ledger) to find where the test enters.

Read `## Review History` only after finishing the five attacks above — earlier, it tells you which ground is already "covered" and becomes the anchor independence exists to remove. Then use it two ways: widen coverage into what no round has attacked, and audit the entries themselves, since a recorded verdict is a claim to verify rather than a settled question. Each entry names the recommendation it reviewed; where that recommendation no longer exists, the entry is history, not evidence — do not re-attack it and do not inherit its conclusions.

Blocking examples: lost user goal, unmeasurable or gameable success metric, no baseline or measurement phase, decorative alternatives, ignored simpler option, mechanism invented for data never confirmed absent, undefined or ownerless contract, missing critical failure handling, proof joining below the behavior it governs, unverifiable phase, dishonest rollback, or dependency cycle. Warnings: oversized phase without a checkpoint, unfamiliar technology, or operational burden without an owner.

## Self-Check (BLOCKING)

- [ ] **Independence:** `independence.md` satisfied — fresh agent, or a session that did not draft; any in-session fallback re-derived every judgment from the document and source; a revision authored in-session was re-reviewed; `## Review History` was read only after my own attacks, and entries naming a superseded recommendation were not inherited. Context: __.
- [ ] **Outcome/options:** goal and measurable outcome hold; each metric was attacked for gameability — naming the gaming change tried, per metric — and every proxy is paired with an outcome guard; alternatives or eliminations were independently challenged, and the document's own simpler-option verdict was re-attacked rather than accepted. Issues: __.
- [ ] **Contracts/failures:** boundaries and required semantics are sufficient; critical failures have detection and recovery. Missing: __.
- [ ] **Migration:** Change/Verify/Rollback gates are credible; destructive steps and applicable cutover/reconciliation hold. Issues: __.
- [ ] **Handoff:** plan graph is actionable; contract↔plan↔phase ownership is complete; every contract's AC/TC is traced to the production entry point it invokes and none joins below the behavior it governs; AC/TC mapping preserves feature Goals. Issues: __.

Report verdict, blocking findings with required revisions, warnings, and author questions. Omit empty sections and generic praise; note a strength only where it is a decision worth preserving under revision.

On every verdict the main agent appends one entry to `## Review History` at the end of the document; the reviewer reports it and never writes it.

```text
### Review <ISO date> — READY | NEEDS REVISION — reviewing: <recommendation named in §3>
Attacked: <metric gaming, simpler option, or failure mode tried> — <what defeated it, or the finding it produced>
Changed:  <contract, phase, or metric revised in response> | none
```

Naming the recommendation is what keeps this usable: an architecture document outlives the plans it spawns and returns to `draft` on any later semantic change, so rounds accumulate across designs that are no longer the design. The name lets a later reviewer tell evidence from history at a glance. Keep entries to what a future reviewer can act on — the diff is already in git.

Any blocking finding → `NEEDS REVISION`; leave `Status: draft` and name the required revisions. Otherwise report `READY`, then run `approval.md`'s `## Architecture` pause — it is the single source for that decision and this skill never adds an exception to it.
