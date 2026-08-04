# /frame-goal — Frame the Goal(s) Before Design

A requirement arrives as one sentence — usually with an issue already tracking it — and a design needs a Goal that is one coherent capability. This skill identifies bundles or ambiguity *before a plan exists to grow around them*. It runs ahead of both design lanes, then routes to design-system (boundary-shaped) or design-feature (feature-shaped). Read project config for AI; unfamiliar area → explore first (PROCESS #10). No plan is read or written here and nothing is designed: the output is goals, never ACs or contracts.

## Procedure

1. **Restate the outcome.** Keep the user's words as the candidate Goal. Requirement phrased as a mechanism ("add a Redis cache") → surface the outcome it serves beside it; whether the mechanism *is* the requirement is the user's call, never a silent rewrite (PROCESS #11).
2. **Decompose** into atomic observable outcomes — actors, triggers, outcomes, constraints, prohibited outcomes, failure behavior — the same decomposition design-feature's derivation step 2 later performs on the chosen Goal.
3. **Too-broad test.** Split when the outcomes are not one capability the user could accept or reject together. For example, "alert on LB errors" and "include the alert in the daily digest" are separate because either can be accepted without the other. Outcome count is a warning only: approaching design-feature's AC heuristic prompts a cohesion check, not an artificial split.
4. **Split boundaries.** Each sub-goal must be an outcome acceptable on its own. Prefer real seams:
   - **capability** — one observable ability per goal;
   - **deployment** — migrations and shared structure first, as the PR Pattern already orders slices;
   - **failure domain** — degraded-mode behavior with its own acceptance surface (own success semantics, own false-positive tolerance) is its own goal, not extra ACs on the happy path.

   Do not manufacture a thin goal solely to meet a numeric target. A large but cohesive capability stays one Goal; design-feature can still use multiple implementation steps or PR slices.
5. **Ambiguity.** Subjective terms, undefined failure behavior, competing readings → ask now, with concrete competing examples, never a silent choice. Every question answered here is one that otherwise resurfaces as a design Open Question or a review round.

## Push-back and confirmation

One goal, the user's outcome preserved, no questions → **no pause**: state the framing in one line and continue. Anything else — a split, a material rewrite, an open question — presents:

```text
| # | Goal (one sentence, outcome not mechanism) | Depends on |
|---|--------------------------------------------|------------|
| 1 | <goal>                                     | —          |
| 2 | <goal>                                     | 1          |
Questions: <competing-example questions, or none>
```

and **waits for the user's answer** — edits, drops, and reordering included. Confirming this list decides *which goals to pursue and in what order*. It is scoping, not spec approval: `approval.md`'s pause still follows each plan's review, unchanged, and nothing here shortcuts it.

## Handoff

Before any `gh` command below, read PROCESS `Git credentials`, the single source for the identity `gh` uses.

- **Route each confirmed goal by shape.** A goal that creates or changes a system boundary, communication pattern, service decomposition, or cross-system integration → design-system (its approved contracts then feed feature plans). Anything else → design-feature. The boundary test is design-system's own opening line; this skill applies it, it does not restate it.
- **Goal 1** (or the lone goal) → its design lane now, verbatim as the `## Goal` / architecture goal. A goal that builds on unmerged work parents per design-feature's PR Pattern rules.
- **A parent issue always exists at handoff — frame-goal guarantees it.** Arrived carrying one → *that* is the parent, untouched. Arrived with none → create it now (`gh issue create`: the requirement, the confirmed goals, the dependencies). This holds for a lone pass-through goal too.
- **Every goal links the parent by default.** Splitting a requirement is not a reason to split its issue: the single issue keeps a multi-goal framing legible. Each goal's plan links it as a parent. Record deferred goals as a GitHub task list — `- [ ] <goal sentence> — depends on <n>` — so each survives the session; `create-pr` ticks an entry when that goal's PR is created, and an unticked entry stops an earlier sibling from closing the parent.
- **A separate issue per goal only when the user explicitly asks for one** — never inferred from goal count, dependency depth, or how unrelated two goals look. Asked → open it per goal and hand each design skill its own number; the parent still tracks the set.

Emit: `Goal framed (#<parent>). Run design-feature.` (or `design-system`) — or `Goals framed (<n>). Run <design lane> for goal 1; #<parent> tracks the set.` Name per-goal numbers instead only where they were explicitly requested.

## Self-Check (BLOCKING)

- [ ] **Outcome fidelity:** every goal is the user's outcome in one sentence, not a mechanism I substituted; any material rewrite was confirmed, not assumed.
- [ ] **Unity:** each goal is one independently acceptable capability; size heuristics prompted a cohesion check but did not force an artificial seam.
- [ ] **Order:** dependencies between goals are explicit and acyclic; no goal depends on a later one.
- [ ] **Push-back:** a split, rewrite, or question paused for the user's answer; a lone verbatim goal proceeded without ceremony; scoping confirmation was never presented as spec approval.
- [ ] **Parent issue:** one exists at handoff — the incoming issue where there was one, otherwise created here, including for a lone pass-through goal; its number is handed to the design lane.
- [ ] **Deferred goals:** every deferred goal survives as a checklist entry in the parent with its dependency named — or holds its own issue only because the user explicitly asked; no issue was opened merely because the framing split. Goal 1's handoff names its design lane (design-system for boundary-shaped goals, design-feature otherwise).
