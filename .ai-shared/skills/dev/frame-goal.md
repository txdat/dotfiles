# /frame-goal — Frame the Goal(s) Before Design

A requirement arrives as one sentence; a design needs a Goal that is one capability. This skill turns the first into the second — the place where a bundled or ambiguous request is split or questioned *before any plan or architecture document exists to grow around it*. It runs ahead of **both** design lanes: every fresh requirement passes through here, and only then routes to design-system (boundary-shaped) or design-feature (feature-shaped). Read project config for AI; unfamiliar area → explore first (CORE #10). No plan is read or written here and nothing is designed: the output is goals, never ACs or contracts, and this skill is the **single source** for the too-broad test and the split boundaries — design-feature's AC budget points here rather than restating them.

## Procedure

1. **Restate the outcome.** Keep the user's words as the candidate Goal. Requirement phrased as a mechanism ("add a Redis cache") → surface the outcome it serves beside it; whether the mechanism *is* the requirement is the user's call to make, never a silent rewrite (CORE #11).
2. **Decompose** into atomic observable outcomes — actors, triggers, outcomes, constraints, prohibited outcomes, failure behavior — the same decomposition design-feature's derivation step 2 later performs on the chosen Goal.
3. **Too-broad test.** A goal is too broad when either fails:
   - **count** — the atomic outcomes exceed design-feature's AC budget (single source for the number and its rationale);
   - **unity** — they are not all one capability the user could accept in a single sitting. This catches bundles under the cap: "alert on LB errors" and "include the alert in the daily digest" fit one sentence, but the user could accept the first while rejecting the second — two goals.
4. **Split boundaries.** Each sub-goal must be an outcome acceptable on its own — the approval pause must be meaningful on it in isolation. Split along:
   - **capability** — one observable ability per goal;
   - **deployment** — migrations and shared structure first, as the PR Pattern already orders slices;
   - **failure domain** — degraded-mode behavior with its own acceptance surface (own success semantics, own false-positive tolerance) is its own goal, not extra ACs on the happy path.
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

- **Route each confirmed goal by shape.** A goal that creates or changes a system boundary, communication pattern, service decomposition, or cross-system integration → design-system (its approved contracts then feed feature plans). Anything else → design-feature. The boundary test is design-system's own opening line; this skill applies it, it does not restate it.
- **Goal 1** (or the lone goal) → its design lane now, verbatim as the `## Goal` / architecture goal. Its issue remains the design skill's to create, as today.
- **Every deferred goal** → its own issue now (`gh issue create`: the goal sentence, why it is deferred, what it depends on), so it survives the session. When a deferred goal is later designed, hand the design skill that issue number so its header starts at `Issue: #<n>` and the reconcile rule updates it instead of opening a duplicate. A goal that builds on unmerged work parents per design-feature's PR Pattern rules.

Emit: `Goal framed. Run design-feature.` (or `design-system`) — or `Goals framed (<n>). Run <design lane> for goal 1; issues #<a>, #<b> hold the rest.`

## Self-Check (BLOCKING)

- [ ] **Outcome fidelity:** every goal is the user's outcome in one sentence, not a mechanism I substituted; any material rewrite was confirmed, not assumed.
- [ ] **Unity:** every goal passes the too-broad test — atomic outcomes within the AC budget and one independently acceptable capability.
- [ ] **Order:** dependencies between goals are explicit and acyclic; no goal depends on a later one.
- [ ] **Push-back:** a split, rewrite, or question paused for the user's answer; a lone verbatim goal proceeded without ceremony; scoping confirmation was never presented as, or mistaken for, spec approval.
- [ ] **Deferred goals:** each has an issue naming its dependency; goal 1's handoff names its design lane (design-system for boundary-shaped goals, design-feature otherwise).
