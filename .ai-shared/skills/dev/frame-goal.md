# /frame-goal — Frame the Goal(s) Before Design

If `~/.dotfiles/.ai-shared/PROCESS.md` is not yet loaded, read it first.

A requirement arrives as one sentence — usually with an issue already tracking it — and a design needs a Goal that is one coherent capability. This skill identifies bundles or ambiguity *before a plan exists to grow around them*. It routes architecture goals to design-system, application goals to design-feature, and live infrastructure operations to design-infra. Read AI project configuration; unfamiliar area → explore first (PROCESS #8). No plan is read or written here and nothing is designed: the output is goals, never ACs or contracts.

## Procedure

1. **Restate the outcome.** Keep the user's words as the candidate Goal. Requirement phrased as a mechanism ("add a Redis cache") → surface the outcome it serves beside it; whether the mechanism *is* the requirement is the user's call, never a silent rewrite (PROCESS #9).
2. **Decompose** into atomic observable outcomes — actors, triggers, outcomes, constraints, prohibited outcomes, failure behavior — the same decomposition design-feature's derivation step 2 later performs on the chosen Goal.
3. **Too-broad test.** Split when the outcomes are not one capability the user could accept or reject together. The test is strictly *independent acceptability*: "can the user ship outcome A without outcome B and call it done?" Yes → separate goals. No → one goal. Outcome count is a warning only: approaching design-feature's AC heuristic prompts a cohesion check, not an artificial split.
4. **Split boundaries.** Each sub-goal must be an outcome acceptable on its own. Cut along real seams — evaluate in this order and apply the first seam that matches; when a boundary could be read as two seams (e.g., a risky failure path is both failure-domain and risk), the earlier seam wins:

   1. **capability** — one observable ability per goal. Two abilities that happen to share implementation are still two goals if either can ship alone.
   2. **deployment** — shared structure (migrations, schemas, new packages) that *two or more goals depend on*, or that has standalone value (e.g., a schema other teams will consume) → own goal, ordered first. Structure that only serves one feature goal stays inside that goal as a PR slice; frame-goal does not split it out.
   3. **failure domain** — degraded-mode behavior with its own acceptance surface (own success semantics, own false-positive tolerance, own monitoring) is its own goal. The test: does this failure path have *different stakeholders, SLOs, or rollback criteria* from the happy path? Yes → separate goal. A simple error message on a known edge case stays an AC.
   4. **risk** — a goal whose feasibility is uncertain (unknown library capability, unproven algorithm, third-party API behavior) splits from goals with known implementation paths so the safe work can proceed and ship regardless of the spike's outcome. The test: if this piece fails or is abandoned, can the remaining goals still ship unchanged? Yes → split it out with explicit spike-or-abandon semantics. No → the risk is intrinsic to the parent goal and stays inside it. A risk goal never appears in a safe goal's dependency chain and may proceed in parallel.

   **Anti-rule:** do not split along team boundaries, file boundaries, or implementation layers — those are PR-slice concerns, not goal concerns. A large but cohesive capability stays one Goal; design-feature handles internal complexity via steps and PR slices.
5. **Ambiguity.** Only surface ambiguity that affects *which goals exist, how they split, or what outcome each represents*. Edge-case behavior within a goal is design-feature's job. Ask with concrete competing examples, never a silent choice. Three scoping-level probes:
   - **Subjective qualifiers** in the goal statement ("fast," "reliable," "user-friendly") → ask for a number or a concrete pass/fail scenario, because the answer can change whether this is one goal or two.
   - **Implicit scope** — does the user expect this to cover existing data, or only new data going forward? The answer often splits a migration goal from a feature goal.
   - **Competing readings** — two plausible interpretations of the outcome → present both as concrete examples and ask which (or both, as separate goals).

   Every question answered here is one that otherwise resurfaces as a design Open Question or a review round.

## Push-back and confirmation

One goal, the user's outcome preserved, no questions → **no pause**: state the framing in one line and continue. Anything else — a split, a material rewrite, an open question — presents:

```text
| # | Goal (one sentence, outcome not mechanism) | Depends on | Spike? |
|---|--------------------------------------------|------------|--------|
| 1 | <goal>                                     | —          | no     |
| 2 | <goal>                                     | 1          | yes    |
Questions: <competing-example questions, or none>
```

The **Spike?** column marks goals split on the risk seam — these carry spike-or-abandon semantics and route to a timeboxed investigation, not a full plan. No safe goal may depend on a spike; a spike may depend on a safe goal (e.g., it needs the migration from goal 1 to experiment against real data).

and **waits for the user's answer** — edits, drops, and reordering included. Confirming this list decides *which goals to pursue and in what order*. It is scoping, not spec approval: `approval.md`'s pause still follows each plan's review, unchanged, and nothing here shortcuts it.

## Handoff

Before any `gh` command below, read PROCESS `Git credentials`, the single source for the identity `gh` uses.

- **Route each confirmed goal by shape.**
  - *Spike goal* (Spike? = yes) → timeboxed investigation, not a full plan. Read-only investigation uses `explore`; feasibility that requires code uses a throwaway prototype branch (no production code, no plan artifact). The deliverable is a recorded proceed-or-abandon verdict, a comment on the parent issue. Proceed → the spike converts to a regular goal and re-enters frame-goal for routing. Abandon → tick and strike the parent checklist entry: `- [x] ~<goal sentence>~ — abandoned (spike)`. The tick satisfies create-pr's "every entry ticked" gate; the strikethrough conveys "abandoned, not shipped."
  - *Boundary goal* — creates or changes a system boundary, communication pattern, service decomposition, or cross-system integration → design-system (its approved contracts then feed feature plans). The boundary test is design-system's own opening line; this skill applies it, it does not restate it.
  - *Infrastructure goal* — migration, deployment, DNS cutover, IaC/database operation, or maintenance on live infrastructure within established boundaries → design-infra, then review-infra, human execution, and review-infra post. Preserve this lane when returning from a bundled/ambiguous infrastructure request. A goal also requiring application changes separates the runbook and application work, with their dependency recorded; the runbook never enters execute-feature or create-pr.
  - *Everything else* → design-feature.
- **Goal 1** (or the lone goal) → its design lane now, verbatim as the `## Goal` / architecture goal. A goal that builds on unmerged work parents per design-feature's PR Pattern rules. Spike goals are never Goal 1 when safe goals exist — safe work starts first.
- **A parent issue always exists at handoff — frame-goal guarantees it.** Arrived carrying one → *that* is the parent, untouched. Arrived with none → create it now (`gh issue create`: the requirement, the confirmed goals, the dependencies). This holds for a lone pass-through goal too.
- **Every goal links the parent by default.** Splitting a requirement is not a reason to split its issue: the single issue keeps a multi-goal framing legible. Each goal's plan links it as a parent. Record deferred goals as a GitHub task list — `- [ ] <goal sentence> — depends on <n>` — so each survives the session; `create-pr` ticks an entry when that goal's PR is created, and an unticked entry stops an earlier sibling from closing the parent.
- **A separate issue per goal only when the user explicitly asks for one** — never inferred from goal count, dependency depth, or how unrelated two goals look. Asked → open it per goal and hand each design skill its own number; the parent still tracks the set.

Emit: `Goal framed (#<parent>). Run the dev-design-feature skill.` (or `dev-design-system` / `dev-design-infra`) — or `Goals framed (<n>). Run the dev-<lane> skill for goal 1; #<parent> tracks the set.` For spike goals: `Goal <n> is a spike — run dev-explore (read-only) or prototype on a throwaway branch; record proceed-or-abandon on #<parent>.` Name per-goal numbers instead only where they were explicitly requested.

## Self-Check (BLOCKING)

- [ ] **Outcome fidelity:** every goal is the user's outcome in one sentence, not a mechanism I substituted; any material rewrite was confirmed, not assumed.
- [ ] **Unity:** each goal is one independently acceptable capability; size heuristics prompted a cohesion check but did not force an artificial seam.
- [ ] **Seam legitimacy:** every split used one of the four named seams (capability, deployment, failure domain, risk); no split was made along team, file, or layer boundaries.
- [ ] **Order:** dependencies between goals are explicit and acyclic; no goal depends on a later one.
- [ ] **Risk isolation:** any goal with uncertain feasibility is marked Spike? = yes in the confirmation table, routes to timeboxed investigation (not a design lane), no safe goal depends on it, and it never appears as Goal 1 when safe goals exist; intrinsic risk stayed inside its parent goal.
- [ ] **Ambiguity surfaced:** scoping-level ambiguity was asked with competing examples; edge-case behavior within a goal was left for design-feature. No silent choices were made.
- [ ] **Push-back:** a split, rewrite, or question paused for the user's answer; a lone verbatim goal proceeded without ceremony; scoping confirmation was never presented as spec approval.
- [ ] **Parent issue:** one exists at handoff — the incoming issue where there was one, otherwise created here, including for a lone pass-through goal; its number is handed to the design lane.
- [ ] **Deferred goals:** every deferred goal survives as a checklist entry in the parent with its dependency named — or holds its own issue only because the user explicitly asked; no issue was opened merely because the framing split. Each handoff preserves its lane: design-system for boundary goals, design-infra for live infrastructure operations, design-feature for application work.
