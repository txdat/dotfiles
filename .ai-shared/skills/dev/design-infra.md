# /design-infra — Infrastructure Runbook Design

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

Use when work touches live infrastructure: migrations, deployments, DNS cutover, IaC changes, load balancer reconfiguration, networking, database operations, scheduled maintenance. **Not** for application features (→ design-feature) or architecture boundaries (→ design-system). Bundled/ambiguous goal? → frame-goal first. Read project config for AI.

**No mutations. Design only.** The runbook is the artifact; execution is the human's call.

Write `docs/runbooks/<date>_<slug>.md` — its own tree, like `docs/architecture/`. Never `docs/plans/`: that tree is plan state, and a runbook is not a plan (`independence.md`, `gate-check`). Heavy analysis may delegate to `architecture-strategist`; the main agent owns the document.

**The agent never executes.** Every phase of this lane is read-only — in both skills, and in any subagent they delegate to. No infrastructure mutation of any kind, ever: not a "safe" step, not a single command lifted out of the runbook, not on direct request. The runbook is written to be run **by a human, on their own authority**. Asked to run it → decline and hand over the phase. That invariant is what lets the lane skip the `approval.md` pause: the human's decision to execute *is* the approval, and it happens outside this flow.

**Lane shape.** `design-infra → review-infra → human executes → review-infra post`. It does not enter `execute-feature`, `review-code`, or `create-pr`, and has no worktree. Statuses are the lane's own — `draft → executed`, or `abandoned` — and are not the plan lifecycle in `README.md`. Infra work that also changes application code splits: the code half goes through the feature lane on its own plan.

`altitude.md` does not apply. Command-level detail is the point of a runbook, not a violation.

Infrastructure's falsifiable chain: **current state (verified) → placement rules → phased execution → verification commands → rollback → gated destruction**.

## Size the document to the change

A single-service deploy needs less detail than a multi-region migration. Keep the core sections; use `Not applicable — <reason>` for sections that don't apply.

| Section | Keep brief when |
|---|---|
| Placement rules | Single workload, single destination |
| DNS / host table | No DNS changes |
| IaC changes | No IaC involved |
| CI/CD workflow changes | No pipeline changes |
| Phased execution | Single atomic operation |

## Design Schema

### 1. Frame

```text
# Runbook: <name>
Status: draft | Date: <date> | Issue: #<n> | Review:
Source: <what exists now — cluster, service, region>
Target: <desired end state>
Constraints: <zero-downtime, external DNS ownership, budget, maintenance window, etc.>
Success: <measurable — "0 traffic to old IP ≥24h", "all hosts resolve new IP", etc.>
```

Each `Success:` criterion must be checkable by a read-only command, and name it. `review-infra post` verifies them one by one after the human executes; a criterion no command can settle cannot be confirmed and will come back as unverifiable.

### 2. Gather live state (MANDATORY — before designing)

Run read-only commands to capture the actual state of every resource the runbook will touch. Record exact values in a `## Current state (verified <date>)` section. Every factual claim must trace to a command output — never assume from documentation or memory.

What to gather depends on the change. Common categories:

| Category | Examples |
|---|---|
| Compute | Workloads (instance count, image tags, health), VM instances, serverless functions |
| Networking | DNS resolution, load balancer rules, IP addresses, network paths, firewall rules, certificates |
| IaC | IaC state/resources, orchestration manifests (e.g., terraform, helm, k8s, pulumi) |
| Data | Database versions, schema state, migration status, backup recency |
| Identity | Service accounts, access bindings, configuration/secrets |
| Existing replacements | Resources already migrated (avoid rebuilding what exists) |

**Floating tags** (`:main`, `:latest`, `:stable`) → flag for digest resolution before execution. Pin exact tags/digests in the runbook.

**Dual-presence** (same workload running on multiple targets) → flag explicitly; drain steps must cover all locations.

### 3. Placement rules

Table: `workload → destination`. Cover every workload on the source. Three categories:

- **Active migration** — moving from source to destination
- **Already done** — destination is live, source needs draining only
- **Do NOT touch** — stays as-is (scaled-to-zero standby, different ownership, out of scope)

### 4. Resource specification

For each workload being migrated, record from the source:

- Image (exact tag, not floating)
- Port(s), probe type, protocol (HTTP/gRPC/TCP/none)
- Resource requests (CPU/memory)
- Configuration/secret dependencies
- Special requirements (helper processes, session affinity, resource constraints, worker pool)

Group into tables by destination type (scale-up, serverless, scheduled job, etc.).

### 5. Phased execution

Dependency-ordered phases. Each phase:

```text
## Phase <N> — <name> (~duration estimate)

Precondition: <what must be true before starting — prior gate, service health, DNS state>

### <N>.1 <step name>
<Exact commands or descriptions. Not pseudocode — runnable.>

Verify: <health check, smoke test, metric query — runnable commands>
Rollback: <exact reversal commands> | IRREVERSIBLE — <why, and what gates protect it>

Gate <N>: <measurable condition to pass before next phase>
```

**Ordering rules:**
1. Backup/baseline before any mutation
2. Build replacement before draining source
3. Verify replacement healthy before DNS cutover
4. DNS cutover before source drain (keep source as rollback)
5. Source drain before destruction
6. Destruction is always last, always gated, always requires human confirmation
7. IaC changes that destroy resources go in the destruction phase

**Grouped resources:** when multiple processes share a deployment target (e.g., a job with helper/sidecar processes), specify each one's image, port, command/args.

### 6. IaC changes (when applicable)

For IaC changes (terraform, pulumi, helm, etc.):

- List exact files and resources to add/modify/remove
- Show the change for each (old value → new value, or "remove block")
- `deletion_protection` or equivalent must be disabled before destroy
- Dry-run / plan review before apply
- State: which resources are destroyed vs modified vs created

### 7. CI/CD workflow changes (when applicable)

For each affected workflow file:
- File path
- What to remove (e.g., deploy-to-old-cluster job)
- What to replace it with (e.g., deploy-to-new-target step)
- Code snippet of the new step

### 8. Host / DNS table (when applicable)

For changes involving DNS or traffic routing:

| Host | Current backend | Current IP | Target backend | Target IP | Status |
|---|---|---|---|---|---|
| `example.com` | old-service | 1.2.3.4 | new-service | 5.6.7.8 | at-risk / ready-to-cut / done |

Separate: at-risk (will break if source deleted), already cut over, to be dropped.

### 9. Destruction checklist

All conditions that must be true before irreversible steps. Checklist format:

```text
- [ ] <condition — measurable, not subjective>
```

### 10. Rollback playbook

Summary table:

| Phase | Rollback method | Time window | Reversible? |
|---|---|---|---|

### 11. Open questions

Unresolved items that block specific phases. Each names which phase it blocks.

### 12. Review History

Empty heading on a fresh draft. `review-infra` appends one entry per READY / NEEDS CHANGES verdict and prunes to the last three; the drafting session never writes an entry. A separate `## Execution Record` is created later by `review-infra post` and never pruned — do not stub it here.

## Validation discipline

Before finalizing the runbook, classify every factual claim:

- **Verified** — command output confirms it (default; no annotation needed)
- **Assumed** — no command run; mark with `(assumed — verify before Phase <N>)`
- **Stale risk** — verified but may drift; mark with `(verified <date> — re-verify before execution)`

## Issue

Link to the tracking issue. If none exists, create one with `gh issue create`. The header reads `Issue: #<n>`.

## Self-Check (BLOCKING)

- [ ] **Live state gathered:** factual claims verified with actual commands, not documentation or memory. Floating tags flagged. Dual-presence workloads identified.
- [ ] **Completeness:** every workload on source accounted for (migrated, drained, or "do NOT touch"). Resource specs recorded from source. CI/CD workflows identified.
- [ ] **Phase ordering:** backup first; build before drain; verify before cutover; drain before destroy; destruction last and gated.
- [ ] **Every phase has:** precondition, runnable verify commands, rollback (or IRREVERSIBLE with justification), and gate.
- [ ] **IaC:** IaC changes specify exact files, resources, and diffs. Deletion protection handled.
- [ ] **Destruction checklist:** covers all gates. No irreversible step lacks a preceding gate.
- [ ] **Open questions empty** or each names the phase it blocks.
- [ ] **Header:** `Status: draft`, `Review:` empty, `Issue: #<n>`. Path is `docs/runbooks/`, not `docs/plans/`.

All checked → save and emit: `Runbook drafted. Run the dev-review-infra skill to review.`
