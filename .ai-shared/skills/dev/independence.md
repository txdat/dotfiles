# Review Independence — Single Source

Referenced by review-feature, review-code, and review-system. A review is worth what its independence is worth: a session that authored the artifact cannot re-derive a judgment it already made, so the rule is about *context*, not effort.

## The rule

**Did this session produce the artifact under review?**

- **No** → review directly in the main session. Nothing else applies.
- **Yes** → delegate the whole review to exactly one fresh agent with no conversation inheritance (EXECUTION_CORE `Subagent context`): its context starts empty except for the packet below. Any delegation mode that forks, inherits, or summarizes this conversation is not fresh and is never valid here, whatever the platform calls it.
- **Yes, but isolation is unavailable** → review in-session, treating authoring memory as untrusted: re-derive every judgment from the artifact file and source reads, never from what you remember deciding.

| Skill | Reviewer | Artifact |
|---|---|---|
| review-feature | `feature-planner` (review mode) | the plan file |
| review-code | `code-quality-auditor` | the worktree plan + `<base>..HEAD` diff |
| review-system | `architecture-strategist` (review mode) | the architecture document |

Independence buys nothing if the fresh agent cannot do adversarial work — an anchored strong reviewer beats an unanchored one that returns counterexample-shaped text. When choosing the model behind these agents, see `capability.md`.

## The packet

Write it to `/tmp/ai-ctx/<slug>.md` and name **only**:

- the artifact path — for review-code, the **worktree** plan copy and the worktree/base refs, never the `$MAIN_ROOT` locator;
- the project config for AI;
- the reviewing skill file (`review-feature.md` / `review-code.md` / `review-system.md`).

Never include authoring rationale, exploration notes, design alternatives you rejected, or a conversation summary. Each of those re-imports the anchor the delegation exists to remove.

## What the reviewer may and may not do

- Applies the **reviewing** skill file, not the drafting one. It judges the artifact as written; it never redrafts it.
- Runs in **one context and spawns nothing**. Size, risk, file count, and independent concerns are not exceptions — process large work as dependency-ordered file or slice batches in the same context.
- May read files, run tests, run `dev-check`, and run read-only Git inspection (`status`/`diff`/`log`/`show`) inside its assigned worktree.
- May **not** mutate Git state, edit files, edit `docs/plans/**` or `docs/architecture/**`, set any `Status:`, or finalize a PR Pattern. Those are the main agent's, acting on the reviewer's evidence.
- Reports findings, counterexamples, and its verdict in the reviewing skill's output shape. The main agent relays them verbatim.

## Re-review

A revision authored in-session is unreviewed text: re-review it as adversarially as the original, or delegate again. After piecewise edits, re-read the whole artifact — a lexical consistency pass catches stale identifiers, not a contradiction between two sections.

Plans and architecture documents carry their own adversarial record (`## Counterexamples Attempted`, `## Review History`), so a re-review meets prior rounds inside the artifact rather than through the packet. That is not a licence to import them early: it is evidence to audit, not a map of what is settled, and each reviewing skill fixes when it may be read. The packet rule above is unchanged — never add the prior round's *conversation* to it.
