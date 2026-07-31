# /frame-goal — Frame the Goal(s) Before Design

A requirement arrives as one sentence — usually with an issue already tracking it — and a design needs a Goal that is one capability. This skill turns the first into the second — the place where a bundled or ambiguous request is split or questioned *before any plan or architecture document exists to grow around it*. It runs ahead of **both** design lanes: every fresh requirement passes through here, and only then routes to design-system (boundary-shaped) or design-feature (feature-shaped). Read project config for AI; unfamiliar area → explore first (PROCESS #10). No plan is read or written here and nothing is designed: the output is goals, never ACs or contracts, and this skill is the **single source** for the too-broad test and the split boundaries — design-feature's AC budget points here rather than restating them.

## Procedure

1. **Restate the outcome.** Keep the user's words as the candidate Goal. Requirement phrased as a mechanism ("add a Redis cache") → surface the outcome it serves beside it; whether the mechanism *is* the requirement is the user's call to make, never a silent rewrite (PROCESS #11).
2. **Decompose** into atomic observable outcomes — actors, triggers, outcomes, constraints, prohibited outcomes, failure behavior — the same decomposition design-feature's derivation step 2 later performs on the chosen Goal.
3. **Too-broad test.** A goal is too broad when either fails:
   - **unity** (run first) — they are not all one capability the user could accept in a single sitting. This catches bundles under the cap: "alert on LB errors" and "include the alert in the daily digest" fit one sentence, but the user could accept the first while rejecting the second — two goals;
   - **count** (run on what unity leaves) — the atomic outcomes exceed design-feature's AC budget (single source for the number and its rationale).

   Neither test subsumes the other: **unity locates seams, count only signals size**. Unity alone drifts — every scope defends itself as one capability at altitude. Count alone is semantically blind, never firing on bundles unity catches. The order keeps both honest.
4. **Split boundaries.** Each sub-goal must be an outcome acceptable on its own — the approval pause must be meaningful on it in isolation. Split along:
   - **capability** — one observable ability per goal;
   - **deployment** — migrations and shared structure first, as the PR Pattern already orders slices;
   - **failure domain** — degraded-mode behavior with its own acceptance surface (own success semantics, own false-positive tolerance) is its own goal, not extra ACs on the happy path.

   **When count fires and unity does not** — an atomic-but-large goal — no seam remains to be found, so one is made: prefer **deployment** (what must merge first becomes its own goal), then the thinnest capability slice that still stands alone. Such a slice is legitimate but thin — "create categories that cannot yet contain anything" — and carries `thin` in the push-back table's `Thin?` column, so the user approves a thin outcome knowingly instead of mistaking it for a full one.
5. **Ambiguity.** Subjective terms, undefined failure behavior, competing readings → ask now, with concrete competing examples, never a silent choice. Every question answered here is one that otherwise resurfaces as a design Open Question or a review round.

## Push-back and confirmation

One goal, the user's outcome preserved, no questions → **no pause**: state the framing in one line and continue. Anything else — a split, a material rewrite, an open question — presents:

```text
| # | Goal (one sentence, outcome not mechanism) | Thin? | Depends on |
|---|--------------------------------------------|-------|------------|
| 1 | <goal>                                     | —     | —          |
| 2 | <goal>                                     | thin  | 1          |
Questions: <competing-example questions, or none>
```

and **waits for the user's answer** — edits, drops, and reordering included. Confirming this list decides *which goals to pursue and in what order*. It is scoping, not spec approval: `approval.md`'s pause still follows each plan's review, unchanged, and nothing here shortcuts it.

`Thin?` reads `thin` only for a count-forced slice (step 4), `—` otherwise. It exists so a thin outcome is visible at the moment the user decides, rather than discovered at that goal's approval pause.

## Handoff

This skill runs ahead of any plan and loads no core file, so read PROCESS `Git credentials` — the single source for the identity `gh` runs under — before any `gh` command below.

- **Route each confirmed goal by shape.** A goal that creates or changes a system boundary, communication pattern, service decomposition, or cross-system integration → design-system (its approved contracts then feed feature plans). Anything else → design-feature. The boundary test is design-system's own opening line; this skill applies it, it does not restate it.
- **Goal 1** (or the lone goal) → its design lane now, verbatim as the `## Goal` / architecture goal. A goal that builds on unmerged work parents per design-feature's PR Pattern rules.
- **A parent issue always exists at handoff — frame-goal guarantees it.** Arrived carrying one → *that* is the parent, untouched. Arrived with none → create it now (`gh issue create`: the requirement, the confirmed goals, the dependencies). This holds for a lone pass-through goal too.
- **Every goal links the parent by default.** Splitting a requirement is not a reason to split its issue: the single issue keeps a multi-goal framing legible. Each goal's plan links it as a parent. Record deferred goals as a GitHub task list — `- [ ] <goal sentence> — depends on <n>` — so each survives the session; `create-pr` ticks an entry when that goal's PR is created, and an unticked entry stops an earlier sibling from closing the parent.
- **A separate issue per goal only when the user explicitly asks for one** — never inferred from goal count, dependency depth, or how unrelated two goals look. Asked → open it per goal and hand each design skill its own number; the parent still tracks the set.

Emit: `Goal framed (#<parent>). Run design-feature.` (or `design-system`) — or `Goals framed (<n>). Run <design lane> for goal 1; #<parent> tracks the set.` Name per-goal numbers instead only where they were explicitly requested.

## Self-Check (BLOCKING)

- [ ] **Outcome fidelity:** every goal is the user's outcome in one sentence, not a mechanism I substituted; any material rewrite was confirmed, not assumed.
- [ ] **Unity:** every goal passes the too-broad test in order — unity ran first and every seam it found was cut, then count was applied to what remained; each goal is one independently acceptable capability within the AC budget.
- [ ] **Order:** dependencies between goals are explicit and acyclic; no goal depends on a later one.
- [ ] **Push-back:** a split, rewrite, or question paused for the user's answer; a lone verbatim goal proceeded without ceremony; any count-forced thin slice was named as thin; scoping confirmation was never presented as, or mistaken for, spec approval.
- [ ] **Parent issue:** one exists at handoff — the incoming issue where there was one, otherwise created here, including for a lone pass-through goal; its number is handed to the design lane.
- [ ] **Deferred goals:** every deferred goal survives as a checklist entry in the parent with its dependency named — or holds its own issue only because the user explicitly asked; no issue was opened merely because the framing split. Goal 1's handoff names its design lane (design-system for boundary-shaped goals, design-feature otherwise).
