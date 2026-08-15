# Review Independence — Single Source

Referenced by review-feature, review-code, review-system, and review-infra. A review is worth what its independence is worth: a session that authored the artifact cannot re-derive a judgment it already made, so the rule is about *context*, not effort.

## The rule

**Did this session produce the artifact under review?** The session that authored the plan/diff/architecture doc is the only session that must delegate. Every other session IS the fresh reviewer — delegating from one adds latency, burns a model×context slot, and gains nothing.

- **No, this session did not author it** → review directly. Nothing else applies. Do not spawn an agent — you are the independent reviewer the rule calls for.
- **Yes, this session authored it** → delegate the whole review to exactly one fresh agent with no conversation inheritance (CODING `Subagent context`): its context starts empty except for the packet below. Any delegation mode that forks, inherits, or summarizes this conversation is not fresh and is never valid here, whatever the platform calls it.
- **Yes, authored here but isolation is unavailable** → review in-session, treating authoring memory as untrusted: re-derive every judgment from the artifact file and source reads, never from what you remember deciding.

| Skill | Reviewer | Artifact |
|---|---|---|
| review-feature | `feature-planner` (review mode) | the plan file |
| review-code | `code-quality-auditor` | the worktree plan + `<base>..HEAD` diff |
| review-system | `architecture-strategist` (review mode) | the architecture document |
| review-infra | `architecture-strategist` (review mode) | the runbook file |

Independence buys nothing if the fresh agent cannot do adversarial work — an anchored strong reviewer beats an unanchored one that returns counterexample-shaped text. Put the strongest available model behind review agents; economize on mechanical phases, never on judgment.

## The packet

Write it to `/tmp/ai-ctx/<slug>.md` and name **only**:

- the artifact path — for review-code, the **worktree** plan copy and the worktree/base refs, never the `$MAIN_ROOT` locator;
- the AI project configuration;
- the reviewing skill file (`review-feature.md` / `review-code.md` / `review-system.md` / `review-infra.md`).

Never include authoring rationale, exploration notes, design alternatives you rejected, or a conversation summary. Each of those re-imports the anchor the delegation exists to remove.

## What the reviewer may and may not do

- Applies the **reviewing** skill file, not the drafting one. It judges the artifact as written; it never redrafts it.
- Runs in **one context and spawns nothing** — process large work as dependency-ordered batches in the same context.
- May read files, run tests, run `dev-check`, and run read-only Git inspection (`status`/`diff`/`log`/`show`) inside its assigned worktree.
- May **not** mutate Git state, edit files, edit `docs/plans/**`, `docs/architecture/**`, or `docs/runbooks/**`, set any `Status:`, or finalize a PR Pattern. For review-infra this extends past the repository: no cloud, cluster, DNS, IaC, or database mutation — read-only commands only. Those are the main agent's, acting on the reviewer's evidence.
- Reports findings, counterexamples, and its verdict in the reviewing skill's output shape. The main agent relays them verbatim.

## Re-review

**Every review cycle is explicitly invoked.** No review skill re-enters itself, and none is triggered by finishing the work its own last verdict demanded. Once the revisions for a verdict are written and committed, the session **stops** — report what changed, say it is unreviewed, and name the skill the user runs when they want it re-reviewed. Do not re-enter, do not dispatch a reviewer, and do not read the user's approval of a revision as authorization for the review after it: it authorizes the edit alone. This holds for review-feature, review-code, review-system, and review-infra alike, and `ship-feature` stops at the same point.

Requiring that invocation is what bounds the loop. Feature-plan review caps at two rounds: round 2 moves non-critical findings to `## Open Risks` and verdicts `READY` — execution's RED phase resolves what design could not. Review-code, review-system, and review-infra have no round cap; repeated revision without convergence there is a signal to surface, not a limit to hit.

Scope, precisely: this governs the **second and later** reviews of an artifact. The *first* review of a freshly drafted plan or document is ordinary routing — `ship-feature` runs it unprompted, and the session that drafted the artifact stays independent by delegating under `The rule` above. What may never be automatic is a review whose subject is a revision this flow just produced.

A revision authored in-session is unreviewed text: re-review it as adversarially as the original, or delegate again. After piecewise edits, re-read the whole artifact — a lexical consistency pass catches stale identifiers, not a contradiction between two sections.

Plans, architecture documents, and runbooks carry their own adversarial record (`## Counterexamples Attempted`, `## Review History`), so a re-review meets prior rounds inside the artifact rather than through the packet. That is not a licence to import them early: it is evidence to audit, not a map of what is settled, and each reviewing skill fixes when it may be read. The packet rule above is unchanged — never add the prior round's *conversation* to it.
