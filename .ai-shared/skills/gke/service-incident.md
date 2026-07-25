---
name: gke-service-incident
description: "Use this skill to investigate GKE service incidents: pod restart cascades, 503/504 errors, service unavailability, CrashLoopBackOff, pods stuck Pending/unschedulable, node autoscaling failures, cloud-provider capacity stockouts, network/VPC problems, and billing/project-suspension events that reclaim nodes. Triggers: 'pods keep restarting', '503/504 errors', 'service is down', 'crash loop', 'pods stuck pending', 'nodes not scaling', 'all nodes disappeared', 'whole node pool gone', 'BILLING_DISABLED', 'REPAIR_CLUSTER', 'ZONE_RESOURCE_POOL_EXHAUSTED', 'VPC/network/firewall issue', 'what caused the incident at <time>'. Inputs (8): GCP project, cluster, region, namespace, affected services, incident start time, duration, timezone — each defaults automatically (project/cluster/region/namespace/services from $GCP_PROJECT_ID/$GKE_CLUSTER/$GKE_REGION/$GKE_NAMESPACE/$GKE_SERVICES; start time & duration default to now; timezone to UTC+7), so it can run with no input when those env vars are set. All cluster queries are read-only — only `gcloud container clusters get-credentials` mutates local kubeconfig and requires confirmation. Never mutate cluster state."
---

# GKE Incident Investigator

**Method**: Observe → Hypothesize → Falsify → Confirm. Data drives queries. ≥2 independent signals
to confirm. A missing expected signal is evidence against.

**The script does the collecting; this file does the judging.** `scripts/gke-collect.sh` runs every
read-only query in one pass and writes a report. Everything below is how to *interpret* that report:
what each signal means, which hypotheses it supports, how to tell confusable causes apart, and when
you are allowed to call something a root cause. Do not re-derive the queries — read the report.

---

## Pre-Flight

Resolve each input from the user's message; **if absent, apply the default** — do not ask for
anything that has one. Only stop and ask (in **one** consolidated message) if a value is still empty
after defaults, i.e. its env var is unset. Always state which defaults you applied.

| # | Variable | Meaning | Default |
|---|----------|---------|---------|
| 1 | `PROJECT` | GCP Project ID | `$GCP_PROJECT_ID` |
| 2 | `CLUSTER` | Cluster name | `$GKE_CLUSTER` |
| 3 | `REGION` | Cluster **location** — region for a regional cluster, zone for a zonal one | `$GKE_REGION` |
| 4 | `NAMESPACE` | Namespace | `$GKE_NAMESPACE` |
| 5 | `SERVICES` | Affected services, comma-separated; trailing `*` = prefix match. Serves as both Service and Deployment set | `$GKE_SERVICES` |
| 6 | `T_USER` | Incident start, as precise as possible | **now** |
| 7 | `T_DURATION` | How long it lasted (widens the window if >30m) | **now** (ongoing) |
| 8 | `T_TZ` | Timezone | `Asia/Ho_Chi_Minh` (UTC+7) |

```bash
export GCP_PROJECT_ID=... GKE_CLUSTER=... GKE_REGION=... GKE_NAMESPACE=... GKE_SERVICES=...
# optional: T_USER, T_DURATION, T_TZ, T_SYMPTOM_LOOKBACK, T_CHANGE_LOOKBACK, T_CRITICAL_LOOKBACK,
#           NODE_DELETE_BURST, NOTREADY_MAX, AGE_RESET_FRAC, PENDING_GRACE_MIN,
#           LB_LOG_LIMIT, LB_5XX_LIMIT, LB_NAME, LB_BACKEND_NAME, POD_NAME, NODE_INSTANCE_ID
```

The script resolves all of this internally and prints it under `Pre-Flight — Resolved Inputs`.
Sanity-check that block before interpreting anything else.

**`REGION` must be the cluster's location.** A zone passed for a regional cluster
(`asia-southeast1-a` vs `asia-southeast1`) 404s every cluster-scoped call, and those sections then
look *empty* rather than failed. The script asks GKE where the cluster lives and prints
`[WARNING] REGION corrected: ...`. If you see it, fix the env var — and note that `CAP_COMPUTE=0`
is usually this, not a missing permission.

**Duration inputs** (`T_DURATION`, the three `*_LOOKBACK`s) accept `\d+(s|m|h|d)` or `date`-native
phrasings. The script normalises them and **aborts** if any resolves to an empty timestamp, rather
than emitting a report whose queries all silently failed.

**Query-window tiers** — a symptom is point-in-time, but a slow root cause can predate it by hours:

| Tier | Span | Env var | Used by |
|------|------|---------|---------|
| Symptom | T−30m → T_END | `T_SYMPTOM_LOOKBACK` | most hypotheses, events, endpoints, LB |
| Change | T−2h → T_END | `T_CHANGE_LOOKBACK` | H7 deploy, H12 network, upgrades/resizes |
| Critical | T−6h → T_END | `T_CRITICAL_LOOKBACK` | B1 billing propagation, H13 long ops, H8 token expiry |

**Multi-service note:** app-log queries filter on the `SVC_RE` regex expanded from `SERVICES`, so
they cover every affected service at once. Endpoint, NEG and single-target `kubectl` commands use
the primary `$SERVICE`/`$DEPLOYMENT` — repeat them per service when `SERVICES` lists more than one.
If an exact service name is a prefix of a sibling (`api` vs `api-order`), verify ownership via the
label selector, not the pod-name regex.

---

## Phase 0 — Auth (Blocking)

The script runs the read-only auth checks (`gcloud auth list`, `config get-value project`,
`kubectl config current-context`, `cluster-info`) on every invocation. It does **not** run
`gcloud container clusters get-credentials` — that mutates local kubeconfig — unless invoked with
`--get-credentials`. Pass that flag only after confirming with the user, or have them run it
manually.

---

## Phase 1 — Broad Sweep

```bash
bash skills/gke/scripts/gke-collect.sh          # read-only; --get-credentials only after confirming
```

It prints one line — the report path — and writes everything else to that file. **Read the report**,
then interpret it with the tables below.

### Retrieving evidence

Every section header carries the hypotheses it feeds, e.g.
`===== 1f.2 — Node Auto-repair =====  {HYP: H13 H14}`. Read the whole file once for the overall
picture; slice by tag when drilling into one hypothesis (the matcher is word-safe — `H1` never
matches `H14`):

```bash
awk -v h=H14 '/^===== /{f=($0 ~ ("[{ ]" h "[ }]"))} f' "$REPORT"   # all H14 blocks with bodies
grep -F '[VERDICT:' "$REPORT"                                      # every detector's state at once
```

**Prefer tags over section numbers.** Section numbering can change; the `{HYP:}` tags and
`[VERDICT:]` lines are the stable interface.

### Verdicts — the five states

| State | Meaning | How to treat it |
|-------|---------|-----------------|
| `FIRES-CRITICAL` / `FIRES-WARNING` | Condition held on readable data | A **candidate signal**, not a conclusion — needs corroboration |
| `CLEAR` | Source readable **and** condition did not hold | A real negative — safe to rule out |
| `UNKNOWN` | Source **unreadable** (auth/IAM/context/log gap) | **Never treat as CLEAR.** The detector could not run; the hypothesis stays open |
| `INFO` | Condition held but a planned op / recovered state explains it | Benign unless it correlates with symptom onset |

`Phase 0b — Capability Preflight` reports which sources are readable (`CAP_LOGGING`, `CAP_K8S`,
`CAP_OPS`, `CAP_COMPUTE`, `CAP_BILLING`). **If a capability is 0, every detector depending on it is
UNKNOWN — an empty query under a missing permission is not an all-clear.** Fix the capability
(grant `roles/logging.viewer`, run `--get-credentials`, correct `REGION`) and re-run before
concluding "nothing found".

False positives are caught by the `INFO` downgrade: H13 checks the maintenance window, H14/H15 check
for an overlapping planned `SET_NODE_POOL_SIZE`/`UPGRADE`/`REPAIR_CLUSTER`, B1 checks current
billing state. **The RCA gate is final: a `FIRES-*` becomes a *cause* only with ≥2 independent
signals that correlate in time with symptom onset.** A single auto-fire, a near-threshold miss, or a
live-snapshot reading is never a conclusion on its own.

### Signal → hypothesis maps

**K8s warning events** `{HYP: H2 H3 H15}`

| Reason | H |
|--------|---|
| `OOMKilling` | H1 |
| `Unhealthy`, `Killing` | H2 |
| `BackOff`, `CrashLoopBackOff` | H1/H7 |
| `Evicted`, `NodeNotReady` | H3 |
| `FailedScheduling` | H3/H4 — also check quota (H4) and stockout (H11) |
| `ScalingReplicaSet` | H4/H7 |
| `FailedMount`, `FailedAttachVolume`, `CreateContainerConfigError` | H7 |
| `FailedCreatePodSandBox`, `NetworkNotReady`, `FailedCreatePodContainer` | H12 |

**Pod restart exit codes** `{HYP: H1}`

| Code | Signal | H |
|------|--------|---|
| `137` | SIGKILL | H1 (OOM) or H2 liveness (ignored SIGTERM) |
| `143` | SIGTERM caught | H3/H7 eviction, H2 liveness |
| `0` | Clean exit | H2 liveness (check `Unhealthy`) |
| `1`/`2` | App error | H2/H5/H6/H8 |
| `139` | SIGSEGV | H7 |

Liveness kill sequence is SIGTERM → grace → SIGKILL: exit 0/143 means the app responded, 137 means
it was force-killed. Confirm via an `Unhealthy/Liveness` event.

**Endpoints** `{HYP: H2}` — `notReadyAddresses` spike + `addresses` drop explains 503s. Then find
why the pods went NotReady.

**System vs manual changes** `{HYP: H3 H4 H7 H8 H9 H11 H12 H13 H14}` — `principalEmail` matching
`system:|gke-|container-engine` is SYSTEM (+4); a human or CI actor is MANUAL (+2). System changes
touch many pods with low visibility, so investigate them first when present.

| System signal | H | Score |
|---------------|---|-------|
| Autoscaler scale-down, node auto-repair, GKE upgrade, spot preemption | H3 | +4 |
| HPA scale-down / scale-up / flapping | H1/H4 · H4/H5 · H2/H4 | +4 |
| IAM policy change, CoreDNS change, VPC/firewall/route/NAT change | H8 · H9 · H12 | +4 |

HPA cascades: scale-down overloads the survivors; scale-up thunders on the DB; flapping churns
endpoints. Note `ZONE_RESOURCE_POOL_EXHAUSTED` (H11) is a **direct signal (+2)**, not a system
change — it is a failure symptom, not an action taken. H12's NAT/IP *exhaustion* is likewise +2,
and stacks with a +4 for a NAT/VPC *change*.

### Load balancer analysis `{HYP: G1 H1-H12}`

Determines traffic-driven vs pod-driven causality.

**Scope.** The script resolves the fronting VIP from **either** an Ingress **or** a Gateway
(`LB_VIP` says which), maps it to a forwarding rule, and separately builds `LB_BACKEND_RE` — the
backend services whose NEG names carry this namespace and these services. It prints
`LB log scope:` telling you which it used. It prefers `backend_service_name` over the forwarding
rule, because one rule commonly fronts every namespace in a project and a shared Gateway would put
other tenants' traffic in your denominator. If it fell back to `forwarding_rule_name`, read the
per-backend block, not the window ratio. If neither resolved, or `logConfig.enable` is false, the
LB steps are skipped and **G1 is UNKNOWN, not CLEAR** — set `$LB_NAME`/`$LB_BACKEND_NAME` and re-run.

**Counts vs ratio — two reads, and the difference matters:**

- **5xx counts (complete across the window)** — every 5xx by minute and by backend, plus status
  codes. Errors are rare enough to fit under the cap, so **this is the authoritative error signal**
  and its onset minute is trustworthy.
- **Traffic volume (SAMPLE)** — a capped read supplying the *denominator* only. It prints
  `SAMPLE_SPAN`, the time range it actually covers.

**Take counts from the first, rate from the second, and never a ratio from the second alone.** At a
few thousand req/min, the cap can cover well under a minute of a 30-minute window, so the sample
routinely reads `5xx_ratio=0.0%` for a window containing hundreds of errors. Check `SAMPLE_SPAN`
against the onset minute before quoting any ratio; to get a real ratio for a burst, re-read that
single minute.

**Interpreting the ratio** (once you have a valid one): <1% background noise, 1–10% partial
degradation, >10% sustained a real outage, ~100% all backends gone. Compare each backend against
the window total — one backend ~100% with healthy siblings means the fault is that service or its
NEG/endpoints, not the cluster; all backends elevated together means cluster/node/network-wide.
`(no-backend-matched)` rows are requests the LB could not route anywhere: an empty-NEG /
all-backends-unhealthy signature, treat as 100%-failure evidence.

Request volume gives causality direction on its own: `total` climbing sharply *while* the ratio
rises = traffic-driven (H4/H11); `total` flat or falling while the ratio rises = pod-driven
(H1/H2/H3/H7). A falling total with a high ratio can also mean clients gave up.

**Status codes:** 502 = pod crashed mid-request (H1/H3) · 503 = no healthy/reachable backend
(H1/H2/H3/H7/H8/H9/H11/H12/B1+H15) · 504 = timeout (H4/H5/H6/H10).

**statusDetails:**

| Value | H |
|-------|---|
| `backend_connection_closed_*` | H1/H3 (killed mid-request) |
| `failed_to_connect_to_backend` | H1/H2/H3/H7/H8/H9/H11/H12/B1+H15 (already dead) |
| `backend_timeout` | H4/H5/H6 |
| `backend_early_response` | H2/H5/H6 |
| `handled_by_identity_aware_proxy`, `forbidden` | H8 |

**Decision matrix** — "spike" means `total` rising within the window (pre-onset minutes are the
comparison, not a T−1d baseline), and every row assumes the *ratio* rose, not merely the count:

| Pattern | H |
|---------|---|
| Spike + 503s | H1/H4/H11 (overload, scale blocked or stockout) |
| Spike + 504s | H4/H5/H6/H10 (saturated or throttled) |
| No spike + 503s | H1/H2/H3/H7/H8/H9/H11/H12/B1+H15 (backend unavailable) |
| No spike + 504s | H5/H6/H10 (dep degraded or CPU throttle) |
| Errors before spike | Retry storm (primary is one of H1/H2/H3/H5/H6/H7/H8/H9/H10) |
| Mixed 503/504 across **multiple services** | H9 (DNS) / H12 (network infra) |
| LB backends UNHEALTHY but pods pass k8s readiness | H12 (health-check firewall/route) |

Latency shape: a rising slow bucket *before* errors = saturation (H4/H5/H6); latency flat with
errors = endpoints dropped (H1/H2/H3/H7).

**G1 is a signal, not a hypothesis.** The 5xx ratio triggers the investigation; score the
underlying causes (H1–H16, B1), never the error ratio itself. Grep `-F '{HYP: G1}'` for its verdict.

### Deploy gate `{HYP: H7}`

No results = H7 ruled out, stop. Results = check system vs manual and set `DEPLOY_TIME` to the
earliest matching event.

### Capacity, network, billing families

| Family | Read when | Key discriminator |
|--------|-----------|-------------------|
| `{HYP: H11 H16}` capacity | Pods stuck `Pending`/`Unschedulable`, autoscaler retrying, or scale-up "decided" but no node appeared | `ZONE_RESOURCE_POOL_EXHAUSTED`/`RESOURCE_POOL_EXHAUSTED` on `instances.insert` = stockout (H11). `QUOTA_EXCEEDED` = H4-quota. `IP_SPACE_EXHAUSTED` = H12. Nodes creatable but late = H16. Read the autoscaler's own decisions (`jsonPayload.decision.scaleUp` / `noScaleUp` / `noDecisionStatus`): a growing gap between `status.autoscaledNodesTarget` and `.autoscaledNodesCount` means decisions never materialised; repeated create→delete of the same instance name ~10s apart (actor `container-engine-robot`) means provisioning kept failing; quota usage well under limit rules out H4-quota; a single-zone `locations` list means a zone stockout blocks scale-up entirely |
| `{HYP: H12}` network | Connectivity broadly broken (multi-service, cross-node, or LB→backend) while pods look healthy, or a VPC/firewall/route/NAT change landed | NAT exhaustion breaks outbound (dep + DNS + GCP APIs) at once. GKE health-check ranges are 35.191.0.0/16 and 130.211.0.0/22 — blocking them flips LB backends UNHEALTHY while k8s readiness still passes. DNS failure is a common *symptom* of H12: healthy CoreDNS with cluster-wide resolution failures points upstream |
| `{HYP: B1 H13 H14 H15}` billing / reclamation | Whole node pools or all nodes disappear, node count drops below `minNodeCount`, all nodes suspiciously young, or a billing/lifecycle event lands | See below |

**Billing & node reclamation — four independently-reported rules.** A disabled billing account
makes GCP suspend and reclaim compute: nodes **vanish** from the cluster (they do not go
`NotReady` — they are gone). When billing is restored GKE fires a `REPAIR_CLUSTER` that recreates
the fleet. `REPAIR_CLUSTER` is **not in Cloud Logging** — only the container operations API shows it.

| Rule | Severity | Fires when |
|------|----------|-----------|
| **B1** | 🔴 CRITICAL | any billing-disabled log entry in the critical window |
| **H13** | 🟡 WARNING | an in-window `REPAIR_CLUSTER` or `UPGRADE_*` container operation |
| **H14** | 🟡 WARNING | in-window MIG node VM deletions reach `$NODE_DELETE_BURST` (default 3) |
| **H15** | 🔴/🟡 | node count below `minNodeCount` (CRITICAL) · NotReady ≥ `$NOTREADY_MAX` (default 2, WARNING) · young/total ≥ `$AGE_RESET_FRAC` (default 0.5, WARNING) |

The real B1 payload contains **"…requires billing to be enabled…"**, *not* the token
`BILLING_DISABLED` — a bare token search misses it, so the scan is field-scoped on `textPayload`.
The disable event often predates node loss by minutes to hours (propagation), hence the T−6h
lookback.

H14's guard: only the MIG's own deletes count — principal `<projnum>@cloudservices.gserviceaccount.com`,
user-agent "GCE Managed Instance Group for GKE". That principal is *not* `system:|gke-|container-engine`,
so generic system-change filters miss it entirely. Human/CI deletes are ordinary maintenance.

H15's guards: a count drop explained by a planned `SetNodePoolSize`/drain is clear; a single
flapping node is noise; a couple of young nodes from routine autoscaling is not a fleet recreation.

**Causal order:** B1 billing disabled → compute reclaimed (H14 delete burst → H15 nodes vanish,
workloads 503) → billing restored → H13 `REPAIR_CLUSTER` → MIG recreates fleet → H15 age reset.
The billing event must **predate** the node loss. A `REPAIR_CLUSTER` with no preceding B1 or
pressure signal is a routine repair, not this family. If a total billing outage stops the cluster's
own control-plane logging, the **absence** of expected logs during the window is itself B1 evidence.

**Before Phase 2, answer:** what is the 5xx ratio and is it one backend or all? Traffic spike?
Dominant status code and statusDetails? System change or manual deploy? Multi-service errors
(→H9/H12)? GCP auth errors (→H8)? CPU throttling (→H10)? Pods Pending — stockout (→H11) or latency
past grace (→H16)? Network change or broad connectivity loss (→H12)? Billing, repair op, delete
burst, or node count below minimum (→B1/H13/H14/H15)?

---

## Phase 2 — Hypothesis Scoring

Score every hypothesis present. No dismissal without evidence. A `FIRES-*` is a candidate needing a
second independent, time-correlated signal; an `UNKNOWN` stays **open** (do not score it 0 — note
the missing capability); an `INFO` counts *against* unless its timing overlaps onset.

| Points | Trigger |
|--------|---------|
| +4 | **System change** — autoscaler, node repair, GKE upgrade, preemption, HPA, IAM policy, CoreDNS, VPC/firewall/route/NAT, billing account change, in-window `REPAIR_CLUSTER`/`UPGRADE_*` (H13), MIG delete burst (H14) |
| +2 | **Direct signal** — the required-signal match for any H (below), **or a manual deploy → H7** |
| +1 | **Indirect signal** — statusDetails match, traffic spike before failures, single `Unhealthy`, `ScalingReplicaSet` |

```
EVIDENCE LEDGER (example — include a row for every scored H)
Signal                          | Timestamp | Source           | Type   | Points To
Cluster autoscaler scale-down   | T-05      | autoscaler logs  | SYSTEM | H3 (+4)
Node gke-pool-abc123 removed    | T-03      | GCE audit log    | SYSTEM | H3 (+4)
OOMKilling event on svc-pod-x   | T+02      | k8s events       | -      | H1 (+2)
Exit code 137 on 3 pods         | T+02      | kubectl get pods | -      | H1 (+2)
Endpoints dropped: 3→0          | T+03      | kubectl describe | -      | all
```

Investigate the highest score first; on a tie prefer system changes over manual.

### The hypotheses

| H | Name | Required signal (must be **present**, not merely plausible) |
|---|------|------------------------------------------------------------|
| B1 | Billing disabled (CRITICAL) | in-window billing-disabled entry OR billing account disable/re-assign |
| H1 | OOMKill | exit 137 |
| H2 | Probe failure | `Unhealthy` event |
| H3 | Node eviction | `Evicted` event |
| H4 | HPA / quota maxed | HPA at `maxReplicas` OR quota hard limit hit |
| H5 | Connection pool exhausted | pool error in app logs |
| H6 | Dependency failure (Memorystore/Redis) | Redis error in logs **+** an instance-side signal |
| H7 | Bad deploy | deploy event |
| H8 | IAM / Workload Identity | `permission denied`/`403`/`PERMISSION_DENIED`/`token expired`/`invalid_grant` in app logs against a GCP API |
| H9 | DNS / CoreDNS | `no such host` cluster-wide |
| H10 | CPU throttling | `cpu/limit_utilization` >0.8 sustained |
| H11 | Cloud capacity stockout (CRITICAL, immediate) | `ZONE_RESOURCE_POOL_EXHAUSTED`/`RESOURCE_POOL_EXHAUSTED` in GCE audit |
| H12 | Network infra / VPC | network infra change in audit OR NAT/`IP_SPACE_EXHAUSTED`/CNI failure |
| H13 | Repair/upgrade op (WARNING) | `REPAIR_CLUSTER`/`UPGRADE_*` op starting in window |
| H14 | Node VM delete burst (WARNING) | deletes ≥ `$NODE_DELETE_BURST` by the `cloudservices` SA |
| H15 | Node count loss / NotReady / age reset | count < summed `minNodeCount`, OR NotReady ≥ `$NOTREADY_MAX`, OR young/total ≥ `$AGE_RESET_FRAC`, unexplained by planned scale-down/drain |
| H16 | Scale-up pending latency (CRITICAL past grace) | oldest Pending age ≥ `$PENDING_GRACE_MIN`m **with** scale-up triggered **and no** stockout |

**H2 sub-variants:** startup (never Ready, high restarts) · liveness (was Ready, high restarts) ·
readiness (running, endpoint flap, low restarts).

**H4 note:** HPA and ResourceQuota are one hypothesis — both starve the scheduler. HPA = blocked by
`maxReplicas` or node capacity; quota = blocked by namespace hard limits. Check both before ruling
out.

### Discriminators — confusable hypotheses

**The authoritative "which of these is it" table.**

| Confusable | The test |
|------------|----------|
| **H1 vs H10** | Exit code + memory. H1 = exit 137, memory spikes to limit, `OOMKilling` present. H10 = exit 0/1/143, memory **flat**, no `OOMKilling`, `cpu/limit_utilization` >0.8 |
| **H2 vs H10** | Why the probe failed. H10 = CPU throttled, so a healthy handler misses a tight `timeoutSeconds`. H2 = CPU normal, the app itself is slow or erroring |
| **H5 vs H6** | Backend health. H5 = client pool full, backend **healthy** (`pool exhausted`/`acquire timeout`, clean DB logs, connections at the pool ceiling). H6 = backend itself degraded — failover, OOM/evictions, maxclients, CPU, or unreachable |
| **H6 vs H8** | Error type + target. H8 = `permission denied`/`403`/`token expired` against a **GCP API**. H6 = `connection refused`/timeout against a dependency. Both look like "can't reach it" |
| **H6 vs H9 vs H12** | Walk in order — (a) **radius**: one downstream service = H6; broad = H9/H12. (b) **CoreDNS's own health**: degraded = H9; healthy while resolution still fails cluster-wide = H12 (break is upstream). (c) **corroborate H12** with a network change or NAT/IP exhaustion while pods stay healthy |
| **H4 vs H11** | Was a VM create attempted, and what did it return? H11 = autoscaler decided, GCE rejected with `ZONE_RESOURCE_POOL_EXHAUSTED`, quota has headroom. H4 = blocked at the Kubernetes layer, no create attempted. `QUOTA_EXCEEDED` = H4-quota |
| **H11 vs H16** | Two faces of Pending. H11 = nodes **cannot** be created (stockout present) — CRITICAL immediately, will not self-resolve. H16 = nodes **can** be created but haven't arrived — CRITICAL only past `$PENDING_GRACE_MIN`m with no stockout. `NotTriggerScaleUp`/max-nodes = H4. Check the stockout scan first |
| **H3 vs H15** | Are the nodes *there*? H3 = present but `Evicted`/`NotReady` under pressure. H15 = **gone** — a reclaimed node vanishes from `kubectl get nodes` entirely, it is never `NotReady` |
| **H11 vs H15** | Direction. H11 = new nodes can't be **created**. H15 = existing nodes were **removed** |
| **B1 vs H13 alone** | Does a billing/pressure signal precede it? B1→H14→H15→H13 is the reclamation chain. A `REPAIR_CLUSTER` with nothing before it is a routine repair |

---

## Phase 3 — Deep-Dive (highest score first)

The script already ran these queries; the sections are tagged with their `{HYP:}`. **Stop at ≥2
independent signals confirming the causal chain.** For each hypothesis, the falsification criteria:

| H | Confirmed if | Ruled out if |
|---|--------------|--------------|
| **B1** | ≥1 in-window billing-disabled entry OR a billing account disable/re-assign | `billingEnabled=True` throughout, no account change, no in-window entries |
| **H1** | `oom_kill_process` in node syslog + exit 137 + memory utilisation >85% in the 5 min before the crash | no `oom_kill_process`, exit codes not 137, memory flat |
| **H2** | Unhealthy events + the sub-variant's fingerprint (below) | no `Unhealthy` events at all |
| **H3** | `Evicted` events + a node condition (Memory/DiskPressure) firing *before* them + FailedScheduling if pods can't reschedule | no `Evicted` events, nodes all Ready, pods spread across healthy nodes |
| **H4** | HPA at `maxReplicas` + high pod CPU/memory + FailedScheduling or blocked autoscaler + 504-dominant | HPA has headroom, pod count scaled, errors are pure 503 |
| **H5** | Pool-exhaustion messages *predate* probe failures + DB server logs clean + DB connections at configured max | no pool messages, DB connections have headroom, DB logs show errors (→H6) |
| **H6** | Redis client errors predate probe failures + a Memorystore-side signal (failover/OOM/maxclients/CPU) + other consumers of the same instance also degraded | no Redis errors; instance READY with normal metrics and no failover; pure `refused/timeout to :6379` with a healthy instance (→H12); pool exhaustion while Redis is healthy (→H5) |
| **H7** | Deploy timestamp precedes the first error + new pods in ImagePullBackOff/CrashLoopBackOff/CreateContainerConfigError/Pending + endpoints dropped as old pods terminated | no deploy in the change window — stop after the gate |
| **H8** | `permission denied`/`403`/`token expired` against a GCP API + an IAM policy change or key expiry predating the errors, OR a WI annotation present with the GCP SA binding missing | no auth errors in app logs, IAM policy unchanged |
| **H9** | `no such host`/`SERVFAIL` across multiple pods + CoreDNS restarts or CPU spike in window | errors limited to one pod/service (→H6), CoreDNS healthy, errors persist after CoreDNS recovery |
| **H10** | `cpu/limit_utilization` >0.8 sustained before probe failures + probe `timeoutSeconds` ≤1 + no OOMKill and memory flat + Unhealthy events present | CPU headroom, generous `timeoutSeconds` (≥5), exit codes 137 (→H1) |
| **H11** | Pods Pending + stockout error on `instances.insert` + quota under limit — CRITICAL immediately | no stockout errors (`QUOTA_EXCEEDED`→H4, no create attempted→H4, created but slow→H16) |
| **H12** | Network infra change (or NAT/IP exhaustion, or CNI failures) + broad connectivity loss + pods and CoreDNS healthy + LB backends UNHEALTHY while k8s readiness passes | failures isolated to one dependency (→H6), CoreDNS degraded (→H9), no change and NAT/subnet have headroom |
| **H13** | An in-window `REPAIR_CLUSTER`/`UPGRADE_*` op | none in window |
| **H14** | In-window MIG deletes ≥ burst by the `cloudservices` SA | below burst, or deletes are human/CI |
| **H15** | Count < summed `minNodeCount` (CRITICAL) / NotReady ≥ max (WARNING) / young fraction ≥ threshold (WARNING), past its guard | count matches pool config, NotReady below threshold, no mass age reset |
| **H16** | Unschedulable pods + `TriggeredScaleUp` + oldest Pending ≥ grace + **no** stockout | Pending within grace (expected), stockout present (→H11), `NotTriggerScaleUp`/max-nodes (→H4), no pods Pending |

**Full-outage (billing family) confirmed if:** B1 fires + H15 count-loss + H14 delete burst +
(usually) H13 `REPAIR_CLUSTER` starting right after billing is restored.

**H16 verdict nuance:** the Pending-age check is a **live** snapshot while the
`TriggeredScaleUp`/`FailedScheduling` evidence is windowed. For a past or recovered incident, trust
the windowed events over a live "does not fire".

### H2 probe red flags

`timeoutSeconds: 1` with any I/O in the handler · `failureThreshold: 1` · an HTTP probe hitting a
DB-querying endpoint (slow under load) · `initialDelaySeconds` too low · startup probe where
`failureThreshold × periodSeconds` < real startup time · no startup probe on a slow-starting app
(liveness kills it during startup).

Sub-variant fingerprints: **startup** = never reached Ready, restarts high · **liveness** = was
Ready before, restarts high, exit 0/143/137 · **readiness** = restarts flat, endpoints oscillating,
app errors during the probe window.

### H5 / H7 sub-causes

**H5** — check the deployment's pool-size env (`DB_POOL_SIZE`, `HIKARI_MAX_POOL_SIZE`, `PG_POOL_MAX`
and friends): unset means the app is on an ORM default, often 10, trivially exhausted under load.

**H7** — `ImagePullBackOff` = wrong tag, registry auth, or image absent · `CreateContainerConfigError`
= missing secret/configmap key or bad env reference · `FailedMount` = PVC unbound or secret/configmap
missing · `CrashLoopBackOff` = app crashes on startup (bad config, missing dep, code bug).

### H6 Redis signal → cause

| App log | Instance-side signal | Cause |
|---------|----------------------|-------|
| `READONLY` / role flip | replication role change / `FailoverInstance` | failover (transient) |
| `OOM command not allowed`, evictions | `memory/usage_ratio` ≈1.0, `evicted_keys` rising | maxmemory reached |
| `max number of clients` / rejects | `reject_connections_count` >0, clients at max | connection ceiling (akin to H5) |
| `LOADING` | instance restarting/restoring | instance restart |
| `connection refused/timeout to :6379` | instance `READY`, metrics normal | network path (→H12), **not** H6 |

**Causal direction:** dependency errors must predate readiness failures. If probe failures came
first, H6 is downstream, not root cause.

### Metrics that are not CLI-queryable

The script prints these as `[MANUAL: ...]` reminders — run them in Cloud Console Metrics Explorer:

```
fetch k8s_container
| metric 'kubernetes.io/container/memory/limit_utilization'   # H1: >0.85 in the 5min before crash
    -- H10: swap for 'kubernetes.io/container/cpu/limit_utilization', >0.8 sustained
| filter resource.cluster_name == 'CLUSTER' && resource.namespace_name == 'NAMESPACE'
     && resource.pod_name =~ 'SERVICE.*'
| within(30m, d'INCIDENT_TIME_UTC') | every 1m
```

```
fetch redis_instance                                          # H6
| metric 'redis.googleapis.com/stats/memory/usage_ratio'      # >0.9 → evictions, writes OOM-rejected
    -- also: clients/connected, clients/blocked, stats/reject_connections_count (maxclients),
    --       stats/evicted_keys, stats/cpu_utilization, replication/master_slave_lag
| filter resource.instance_id =~ '.*' | within(30m, d'INCIDENT_TIME_UTC') | every 1m
```

### Contributing factors worth noting per family

H1: limits set without profiling peak load; single replica; no PodDisruptionBudget.
H11: single-zone node pool (no fallback); no alternate machine-family pool; no capacity reservation.
H12: overly broad firewall/route edits; undersized Cloud NAT; secondary ranges near exhaustion.
B1: single-zone pools (one zone's reclamation removes the whole pool); no billing budget alert to
page before nodes are reclaimed; payment expiry or spending cap.

---

## Phase 4 — Cross-Correlation (all 6 before RCA)

| # | Check | Rule |
|---|-------|------|
| 1 | Timestamp order | Root cause < all downstream. Out of order = invalid |
| 2 | Two signals | Each confirmed H needs ≥2 **independent** signals correlating in time with onset — different sources (node syslog + `kubectl`), not the same fact twice. B1 alone suffices for the critical root cause |
| 3 | Parsimony | Does one H explain all signals? Don't force-fit a second |
| 4 | Required signal | Must be **present**, not plausible. Missing = ruled out, however good the story |
| 5 | User match | Data ≠ reported time? The real incident started earlier |
| 6 | Traffic direction | spike < k8s event = traffic caused · k8s event < spike = retry storm · flat = pod-only |

---

## Phase 5 — RCA Report

```
## GKE Incident Report

Cluster:      <name> / <region>
Namespace:    <namespace>
Services:     <service names>
Query window: <T_START UTC> → <T_END UTC>
Impact:       <T_first_symptom UTC> → <T_fully_recovered UTC>
MTTD:         <first symptom → first alert>      MTTM: <first alert → fully restored>

### Affected Scope

**Pods** — table: Pod | Container | Restarts | Exit Code | Down From | Recovered At
**Replicas** — desired / min healthy during incident / peak unhealthy
**Endpoints** — per service: addresses normal | addresses min | NotReady peak
**Error Volume** — total 5xx | total requests | peak per-min ratio | window ratio |
                   dominant status code | partial vs full outage
**Nodes affected** — <names or "none"> (eviction / preemption / pressure)
**Blast radius** — other services or namespaces degraded

### Root Cause
<One precise sentence: what failed, why, when.>

### Causal Chain
| Time (UTC) | Event | Source |
(root cause first, then each downstream effect through to recovery)

### Evidence Ledger
| Signal | Value | Source | Timestamp |

### Traffic Analysis
| Metric | Pre-onset (in-window) | Peak / Incident |
request rate · 5xx ratio · onset minute · dominant status code · dominant statusDetails ·
worst backend · traffic spike? · spike vs pod failure · causality direction

### Hypotheses Evaluated
| # | Hypothesis | Verdict | Key Evidence |
(every H — CONFIRMED / RULED OUT / UNKNOWN-with-reason, each with its evidence)

### Contributing Factors
### Blind Spots
(data unavailable, log gaps, hypotheses not falsifiable for want of data — and any
 capability that was 0, since those detectors were UNKNOWN rather than clear)
```

---

## Safety Rules

**Allowed:** `kubectl get/describe/logs/top/rollout history` · `gcloud logging read` ·
`gcloud monitoring metrics list` · `gcloud compute/container describe` ·
`gcloud container operations list` · `gcloud container node-pools list` ·
`gcloud billing projects describe` · `gcloud auth list` · `gcloud config get-value` ·
`gcloud container clusters get-credentials` **after confirmation**.

**Never:** `kubectl apply/delete/edit/patch/exec/cp/port-forward` · `gcloud create/delete/update/set/patch`.
Redact secrets.

Every command in `gke-collect.sh` stays within the allowed list; the only state-mutating step
(`get-credentials`, kubeconfig only) is gated behind an explicit flag.

---

## Common Pitfalls

Mechanical traps — things that make a query lie or hide evidence. For "is it Hx or Hy?" see
**Discriminators**.

| Area | Pitfall | Fix |
|------|---------|-----|
| Logs | K8s events expire ~1h in etcd | Query Cloud Logging, not `kubectl get events` |
| Logs | Cloud Logging 30-60s lag | Extend window ±5min |
| Logs | textPayload vs jsonPayload | Query both |
| Logs | `--previous` shows last crash only | Cloud Logging for full history |
| Logs | `gcloud logging read` defaults to limit=1000 | Set `--limit` explicitly (≤50000) |
| Pod | Multi-container: which crashed? | Specify `--container` |
| Pod | Restarts=0 ≠ healthy | H2 readiness: running but excluded from endpoints |
| Pod | Startup vs liveness event | Message says "Startup probe failed" |
| Codes | 503 vs 504 | 503 = no healthy backend; 504 = timeout |
| Codes | 502 timing | `backend_connection_closed` died mid-request; `failed_to_connect` already dead |
| Time | GCP timestamps are UTC | Convert the user's timezone first |
| Time | Retry storm looks like a spike | Compare LB spike vs k8s event timestamps |
| LB | Sample ratio reads 0.0% on a busy LB | The sample covered seconds — check `SAMPLE_SPAN`, take counts from the complete 5xx read |
| LB | Gateway cluster has no Ingress | GKE Gateway creates forwarding rules with no Ingress object; VIP comes from `kubectl get gateway` |
| LB | Shared LB dilutes the ratio | One rule fronts every namespace — scope by `backend_service_name` |
| LB | Log sampling at high RPS | Verify `logConfig.sampleRate` |
| LB | Multiple forwarding rules | Check internal **and** external LBs |
| LB | NEG health-check lag | LB health checks differ from k8s readiness |
| kubectl | `top` is current-only | Metrics Explorer MQL for history |
| kubectl | Label selector mismatch | Verify `matchLabels` first |
| Node | Instance ID not in the event | `kubectl describe pod` → node → GCE ID |
| Node | System changes are invisible in app logs | Always read the system-change sections |
| Node | Spot/preempt gives 30s warning | `terminationGracePeriodSeconds > 30` → SIGKILL |
| HPA | Scale-down cascade | Fewer pods → overload → more die |
| HPA | Scale-up thundering herd | All pods hit the DB at once → H5 |
| H10 | No CPU limit = no throttling | Only occurs when `.resources.limits.cpu` is set |
| H11 | Autoscaler "works" but no nodes | A scale-up *decision* ≠ a node created; watch the target/count gap and create→delete churn |
| H11 | Single-zone pool hides the fallback | A zone stockout fully blocks it; multi-zone or NAP would have fallback |
| H12 | Healthy pods but LB UNHEALTHY | Firewall change blocking 35.191.0.0/16 or 130.211.0.0/22 |
| H12 | `IP_SPACE_EXHAUSTED` ≠ capacity | Subnet/pod-CIDR exhaustion is H12, not H11 |
| H13 | Repair/upgrade ops invisible in logs | Only `gcloud container operations list` shows them |
| H14 | MIG deletes missed by system-change filters | The MIG acts as `cloudservices`, not `system:/gke-/container-engine` |
| B1 | `BILLING_DISABLED` search comes back empty | The payload says "…requires billing to be enabled…" — field-scope `textPayload` |
| B1 | Monitor silent during the outage | Billing kills the project, so in-project logging may not run — absent logs are themselves a B1 signal; page via an external budget alert |
