# Review Independence — Single Source

Referenced by review-feature, review-code, review-system, and review-infra. A review is worth what its independence is worth: a session that authored the artifact cannot re-derive a judgment it already made, so the rule is about *context*, not effort.

## The rule

**Did this session produce the artifact under review?** The session that authored the plan/diff/architecture doc is the only session that must delegate. Every other session IS the fresh reviewer — delegating from one adds latency, burns a model×context slot, and gains nothing.

- **No, this session did not author it** → review directly; delegation adds no independence. The remaining authority and evidence rules still apply.
- **Yes, this session authored it** → delegate the whole review to exactly one fresh agent with no conversation inheritance (CODING `Subagent context`): its context starts empty except for the packet below. Any delegation mode that forks, inherits, or summarizes this conversation is not fresh and is never valid here, whatever the platform calls it.
- **Yes, authored here but isolation is unavailable** → review in-session, treating authoring memory as untrusted: re-derive every judgment from the artifact file and source reads, never from what you remember deciding.

| Skill | Reviewer | Artifact |
|---|---|---|
| review-feature | `feature-planner` (review mode) | the plan file |
| review-code | `code-quality-auditor` | the worktree plan + `<review-base>..HEAD` diff (first slice's Parent) |
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
- Reports findings, counterexamples, and its verdict in the reviewing skill's output shape. The main agent may consolidate the report while preserving the verdict, material findings, evidence, uncertainty, and unresolved decisions.

## Re-review

**Use the authorized scope.** A review-only request ends with findings; it does not authorize edits. If the user later authorizes only an edit, report its verification and leave a full re-review for a new request. An end-to-end delivery request, or explicit authorization to revise and verify, includes independent re-review of those in-scope revisions. The main agent routes it without another permission pause; the reviewer itself remains read-only. Initial reviews follow the same authority and independence rules.

Before an automatic repair/re-review pass, confirm all three:

- The user's request includes delivery or revision-and-verification for this named artifact.
- The repair stays within that scope; implementation preserves the approved spec. Unresolved spec, dependency, external-effect, or risk decisions pause dependent work.
- Fewer than two automatic repair/re-review passes have run for this artifact under the current authorization.

Record `Repair pass: 1/2` or `2/2` with the changes and verification in `## Review History`. A pass consists of applying findings and independently reviewing that revision. After the second pass, remaining findings that require another repair → report them and pause for user direction. Renaming a finding, changing its hypothesis, or spawning another reviewer does not reset the budget. Optional refinements may be explicitly skipped. A successful review proceeds to the next authorized phase. Only explicit user direction renews an exhausted repair budget.

After revisions, verify the changed behavior and affected dependencies, and reread the artifact for cross-section conflicts. Reuse evidence only when its code, spec, dependencies, and environment remain applicable. The current artifact must satisfy the full readiness criteria; focused re-verification cannot conceal an unresolved finding. User decisions, spec amendments, and material scope or risk changes still follow `approval.md` and PROCESS #4/#6. Runbook revision and review never authorize infrastructure execution.

Stop earlier if the same blocking finding recurs without new evidence or reduced uncertainty. Report attempts, the unresolved cause, and the decision or evidence needed. Optional refinements do not block readiness, and exhausting a retry budget never converts a defect into a pass.

Prior findings remain in the artifact's `## Review History`. Read them at the reviewing skill's prescribed point, after forming an independent view. Preserve the packet boundary: do not import the author's conversation or prior verdict as instructions to agree.
