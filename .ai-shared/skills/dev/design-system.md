# /design-system — Architecture Design

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

Use only when work creates or changes a system boundary, communication pattern, service decomposition, or cross-system integration. **A new endpoint on an existing service is not a system change** — that belongs to design-feature. Bundled/ambiguous goal? → frame-goal first. No code. Write `docs/architecture/<date>_<slug>.md` after reading project config for AI. Heavy analysis may delegate to `architecture-strategist`; the main agent owns the document and the later human decision.

Architecture's falsifiable chain: **goal + constraints → options → recommendation → boundary contracts → reversible phases → measured outcome**. Feature plans then prove observable behavior through Goal → AC → TC → RED → GREEN → BLUE.

## Size the document to the change

**A single-boundary change (e.g., add a queue between A and B) needs less detail than a new service.** Keep the five headings for stable handoff, but use a one-line `Not applicable — <reason>` instead of inventing content:

| Section | Keep brief when |
|---|---|
| Compare options | Only one viable option (justify the elimination) |
| Migration phases | No migration (e.g., greenfield service) |
| Decomposition | Single plan covers everything |

## Design Schema

### 1. Frame

Clarify the user outcome, current pain, constraints, scale, team capacity, affected boundaries, current integration, and measurable success.

```text
# Architecture: <name>
Status: draft | Date: <date>
Current: <flow> | Pain: <issue → impact>
Constraints: <constraint — why>
Contexts: <affected boundaries and integration>
Success: <metric target> | Baseline: <current measurement, or unavailable — first measurement phase>
```

Success must be measurable after the final phase. If no baseline exists, the first phase establishes it; subjective goals such as "cleaner" or "more scalable" need an observable measure.

### 2. Compare viable options

Compare 2–3 viable options when they exist. If hard constraints leave one, show which alternatives they eliminate. For each: complexity, migration, operations, team fit, rollback, coupling, dependencies, and critical failure → detection → recovery. **Attempt the simpler-option counterexample:** *could a simpler option meet the same goal and constraints?* Then test the evolution path: *could this start as a simpler working system and grow later?* Complexity beyond that starting point needs a current requirement or evidence—such as measured load, compliance, compatibility, or failure cost—not speculative scale alone.

### 3. Recommend

Recommend one option with rationale tied to the goal, constraints, and evidence. State trade-offs and rejection reasons. Define each changed boundary contract at `altitude.md`'s notation level — `<producer> → <consumer>: <event/call> — invariant`, never target-language syntax; include ownership, compatibility/versioning, timeout/delivery semantics, and failure handling when relevant. For each changed boundary, inspect credible consumer dependence beyond the documented contract—errors, defaults, ordering, timing, or side effects—using callers, telemetry, documentation, or history where available. Preserve it, migrate it explicitly, or record why breakage risk is acceptable. If analysis finds no boundary change, stop and route the work to design-feature instead of producing an architecture document.

### 4. Migrate safely

When migration is needed, define dependency-ordered, independently deployable phases. Each phase is a falsifiable gate:

```text
Phase <n>: <deliverable> (~duration)
Change:   <what becomes true>
Verify:   <objective pass/fail check — metric, query, probe, or test>
Rollback: <concrete restoration steps, or not applicable — reason>
```

State dual-run/synchronization, cutover trigger, and reconciliation when applicable. A destructive or irreversible step requires explicit containment and recovery; never label it rollbackable when it is not.

### 5. Decompose

When multiple plans are needed, list each by name, owning phase, dependencies, delivered outcome, and assigned contracts. No cycles; at least one plan must be initially actionable. For one plan, name it and its assigned contracts in one line. Do not create plan files here: design-feature creates each plan when its dependencies permit.

**BDD handoff:** every changed contract is assigned to a plan and cited as a source, constraint, or invariant. Its observable behavior must be covered by an AC and TC per design-feature; internal topology is not itself an AC. Each plan preserves its user Goal and cites this document and phase in Context. A contract no plan owns is unimplemented; a plan no phase needs is scope creep. After the final phase ships, measure Success against the baseline.

## Self-Check (BLOCKING)

- [ ] **Frame and options:** goal, pain, success, baseline/measurement phase, constraints, and boundaries are concrete and measurable. Viable choices or constraint-based eliminations are honest; the simpler option and simpler starting system were tested in §2. Complexity beyond that start answers a current requirement or evidence. Rationale follows evidence; documented and credible de facto contracts cover compatibility, delivery, and failure semantics.
- [ ] **Migration:** applicable phases are ordered and independently deployable; each has Change/Verify/Rollback. Destructive steps, cutover, synchronization, and reconciliation are handled where present; omissions have a concrete reason.
- [ ] **Handoff:** when multiple plans are needed, decomposition is acyclic and actionable; every contract has a plan and every plan a phase. A single-plan design says so directly. Contract behavior is assigned to later AC/TC proof without replacing plan Goals.

All checked → save and emit: `Run the review-system skill.`
