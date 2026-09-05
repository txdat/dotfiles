# /review-infra — Infrastructure Runbook Review

Entry: exact `docs/runbooks/<file>.md`. No latest-document fallback. Read the runbook, the AI project configuration, and any referenced IaC files, orchestration manifests, and CI/CD workflows. Challenge correctness against live state, not field presence.

**This skill is the pre-execution review** — `## Review process` below, validating a `Status: draft` runbook before a human runs it. That is what a bare invocation does. `post <file>` is the one opt-in variant: an audit of what actually happened after they ran it. Nothing else selects it, and an ambiguous request resolves to the default — auditing a runbook nobody ran produces nothing, while re-validating one that already ran costs only time.

`post` additionally requires the human to confirm it was executed. No confirmation, no `## Execution Record`, and no live evidence of a phase having run → wrong mode: say so and offer the default review.

**Read-only throughout.** Every command this skill or its delegate runs is read-only — no infrastructure mutation of any kind, on any request (`design-infra` `The agent never executes`). `post` audits an execution; it never finishes, resumes, remediates, or rolls one back. Asked to → decline and report what needs running.

Review the chain: **current state (verified) → placement rules → phased execution → verification commands → rollback → gated destruction**.

## Independence and invocation

Follow `independence.md` for reviewer context, revision authority, re-review, and non-convergence. Any `Status` change stays with the main agent. Authorized runbook authoring and review may continue through document revisions; review-only requests end with findings. Neither scope authorizes infrastructure execution.

READY is not an approval. The infra lane has no `approval.md` pause (`design-infra` `Lane shape`) — READY says only that the runbook is safe to hand a human. Whether to run it is theirs to decide.

## Review authority

Review reports findings; it does not rewrite the runbook. Route by type:

- **Factual error** (image tag, instance count, DNS, resource state) → report with live evidence
- **Missing step** (undrained workload, uncovered host, missing rollback) → report what's missing and where
- **Ordering error** (drain before build, cutover before verify) → report the dependency violation
- **Stale claim** (state changed since verification date) → report both values

**Report only what affects execution correctness.** Style, wording, and formatting go in one grouped `Nits:` line and are never a reason to withhold READY.

## Review process

### 1. Live state validation (MANDATORY)

Run read-only commands to check every factual claim in the runbook. Use whatever tools are appropriate — CLIs, IaC tools, dig, curl, database clients, API calls.

For each claim, report:

| Verdict | Meaning |
|---|---|
| MATCH | Runbook claim matches live state |
| MISMATCH | Runbook says X, live says Y (include both) |
| MISSING | Runbook references something that doesn't exist |
| EXTRA | Live state has something runbook doesn't account for |
| STALE | Was correct at verification date, now changed |

**Minimum checks** (when applicable to the runbook's scope):

- Workload state: instance count, image tags, health status
- DNS resolution for affected hosts
- IaC resources exist and match runbook descriptions
- Existing services/replacements that runbook says to build or skip
- Network state: IPs, load balancer rules, certificates, firewall rules
- Image tags: from source (not stale target); floating tags flagged

### 2. Phase ordering review

- [ ] Backup/baseline phase exists and runs first?
- [ ] Replacements built and verified before source drain?
- [ ] DNS cutover happens after replacement is healthy?
- [ ] Source kept alive as rollback target until cutover is verified?
- [ ] Destruction is last, gated, and marked irreversible?
- [ ] No phase depends on a later phase's output?
- [ ] IaC destroy comes after all dependent resources are migrated?

### 3. Rollback review

- [ ] Every non-read-only phase has a rollback method?
- [ ] Irreversible steps are clearly marked and gated?
- [ ] Rollback commands are concrete (not "revert changes")?
- [ ] Rollback time window is stated?
- [ ] Rollback is tested or testable (not theoretical)?

### 4. Completeness review

- [ ] Every workload on source accounted for (migrated, drained, or "do NOT touch")?
- [ ] Dual-presence workloads (running on multiple targets) have drain steps for ALL locations?
- [ ] "Do NOT touch" list matches actual state (e.g., zero-instance workloads really are zero)?
- [ ] IaC changes include all related resources (not just the primary — also IP, firewall, subnet, DNS records)?
- [ ] CI/CD workflows cover all affected services?
- [ ] Host/DNS table accounts for every host pointing to source?
- [ ] Resource specs (image, port, probe, config) match source?
- [ ] Floating tags flagged for digest pinning?
- [ ] Secret/config handling follows existing patterns?
- [ ] Destruction checklist covers all necessary gates?

### 5. Risk review

- [ ] Any host that would lose its backend if source is deleted now?
- [ ] Any workload that would stop processing if drained before replacement is ready?
- [ ] Grouped resources (workloads with multiple processes/containers) have correct specs per process?
- [ ] Maintenance window or traffic impact estimated?
- [ ] External dependencies identified (DNS team, cert provisioning, third-party APIs)?

### 6. IaC review (when applicable)

- [ ] IaC files and resources listed match what exists in the codebase?
- [ ] Deletion protection handling is explicit?
- [ ] Subnet/network resources that depend on the destroyed resource are handled?
- [ ] Dry-run / plan review step exists before apply?

Read `## Review History` only after completing the checks above. Use it to widen coverage and audit entries — a prior verdict is a claim to verify, not a settled question.

## Post-execution audit (`post` only)

Ground truth flips. The default review validates the **Source** claims that gate execution; this audits the **Target** the runbook promised. Establish what actually ran before checking anything — ask the human, and read `## Execution Record` for prior attempts. Never assume the runbook was followed exactly; the gap between it and what happened is the point.

A runbook executed without a `Review: READY` marker was run unvalidated. Record it as a HIGH finding and audit it more widely — its preconditions were never checked.

1. **Success criteria** — each `Success:` line in `## Frame`, verified by its command. Met / not met / unverifiable.
2. **Phase ledger** — per phase: ran, skipped, partial, or rolled back, plus its gate's actual outcome.
3. **Divergence** — commands run that the runbook did not specify, and specified steps done differently.
4. **Destruction audit** — retrospective: did every irreversible step have its gate satisfied *before* it ran? A step that happened to work with an unmet gate is still a finding.
5. **Residue** — resources the runbook meant to remove that still exist: orphaned IPs, disks, DNS records, images, service accounts, access bindings, firewall rules. Floating tags never pinned.
6. **Rollback status** — per phase, still reversible, or window expired?
7. **Remaining work** — phases not yet run, with preconditions **re-verified against current state**. A precondition checked at draft time may have gone stale mid-execution.

Verdict ladder, first match wins:

| Verdict | Condition |
|---|---|
| **UNSAFE** | An irreversible step ran with its gate unmet, or residue creates present risk. Reported regardless of whether the outcome happened to be fine — the process failed even when the result did not. |
| **DIVERGED** | End state differs from Target in a way the runbook did not plan. Needs a human decision: accept, remediate, or roll back. |
| **INCOMPLETE** | Runbook followed as written; phases remain. Name what remains and whether its preconditions still hold. |
| **COMPLETE** | Every Success criterion verified by command, no residue, nothing remains. |

The main agent appends the reviewer's evidence as one entry per execution attempt to `## Execution Record`. **Never pruned** — this is the execution audit trail, and an entry describing an irreversible action stays for as long as the runbook does:

```text
### Executed <ISO date> — UNSAFE | DIVERGED | INCOMPLETE | COMPLETE
Ran:      <phases that ran, with gate outcomes>
Diverged: <what differed from the runbook> | none
Residue:  <resources still present that the runbook meant to remove> | none
Remains:  <phases not run; preconditions re-verified?> | none
```

`COMPLETE` → main agent sets `Status: executed`. Every other verdict leaves `Status: draft` — the runbook is still live work. A runbook needing further phases stays runnable as-is; one whose remaining phases no longer fit current state goes back to `design-infra` for revision, and the audit says which. `abandoned` is never a verdict: stopping a half-executed migration is the human's decision, and the audit's job is to tell them what stopping leaves behind.

## Severity levels

| Level | Criteria |
|---|---|
| **HIGH** | Wrong image tag, missing drain step, phase ordering error, host would lose backend, missing rollback for destructive step, IaC resource missed |
| **MEDIUM** | Stale data in tables (was correct, now changed), missing dual-location drain, incomplete CI/CD coverage, assumed-but-unverified claim |
| **LOW** | Already-completed items still listed as TODO, wording/style issues, non-blocking nits |

`post` adds: **HIGH** — irreversible step run with its gate unmet, residue creating present risk, Success criterion not met, executed without a `Review: READY` marker. **MEDIUM** — undocumented divergence with a benign outcome, expired rollback window not recorded, remaining phase whose precondition has gone stale.

## Self-Check (BLOCKING)

Always:

- [ ] **Read-only:** every command run was read-only. No infrastructure state was mutated, and nothing in the runbook was executed, resumed, or remediated.
- [ ] **Authority and independence:** reviewer context and revision authority satisfy `independence.md`. Prior verdicts were read only after my own checks. Review reported findings and did not rewrite the runbook. Non-execution findings are in one `Nits:` line.

Default review:

- [ ] **Live validation done:** ran read-only commands to validate claims — not just read the runbook. Every MISMATCH reported with both runbook value and live value.
- [ ] **Phase ordering:** verified backup-first, build-before-drain, verify-before-cutover, drain-before-destroy, destroy-last-and-gated.
- [ ] **Rollback:** every mutating phase has rollback; irreversible steps are gated.
- [ ] **Completeness:** all workloads, hosts, IaC resources, and CI/CD workflows accounted for. Dual-presence and floating tags checked.
- [ ] **Risk:** no host would lose backend; no workload would stop before replacement is ready.

`post` instead:

- [ ] **Execution confirmed** by the human before auditing — this was not a bare runbook reviewed in the wrong mode.
- [ ] **What ran established** from the human and `## Execution Record` — not assumed from the runbook's own text.
- [ ] **Every Success criterion** checked by its command and ruled met / not met / unverifiable.
- [ ] **Destruction audited retrospectively:** every irreversible step that ran had its gate satisfied first, or it is a HIGH finding.
- [ ] **Residue swept** and remaining phases' preconditions re-verified against current state, not against the draft.

Report: severity-ranked findings table, then the verdict — READY or NEEDS CHANGES by default, UNSAFE / DIVERGED / INCOMPLETE / COMPLETE in `post`.

On every READY or NEEDS CHANGES verdict, the main agent appends a concise `## Review History` entry. Preserve unresolved findings and the evidence needed to assess progress; non-convergence follows `independence.md`, not a count of prior verdicts.

```text
### Review <ISO date> — READY | NEEDS CHANGES
Validated: <what was checked against live state — categories and command count>
Findings:  <HIGH: N, MEDIUM: N, LOW: N — key issues named>
Changed:   <what was fixed in response> | none
```

Blocking finding → `NEEDS CHANGES`; leave `Status: draft`. Otherwise `READY`; the main agent writes `Review: READY <date>` in the header. For `post`, the main agent records the reviewer's evidence under `## Execution Record` instead, per `Post-execution audit`. The delegated reviewer edits neither record.

READY is a handoff, not a start. End the review by naming the human as the executor — never offer to run a phase, and never read the user's approval of a revision as authorization to execute the runbook.
