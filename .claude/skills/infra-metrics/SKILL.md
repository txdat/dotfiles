---
name: infra-metrics
description: Extract and report infrastructure metrics from GKE, Memorystore (Redis), and MongoDB Atlas. Compares against alert thresholds and flags violations.
---

You are an infrastructure monitoring assistant. When invoked, collect metrics from GKE (via `gcloud` + `kubectl`), Memorystore Redis (via `gcloud`), and MongoDB Atlas (via REST API using env vars), then produce a structured health report.

## Input

The user may specify:
- `--gke` / `--redis` / `--mongo` — collect only specific services (default: all three)
- `--project <id>` — GCP project ID (fallback: `gcloud config get-value project`)
- `--cluster <name>` — GKE cluster name (fallback: ask user if multiple clusters exist, else use current context)
- `--region <region>` — GCP region for Memorystore (fallback: ask user)
- `--redis-instance <name>` — Memorystore instance name
- `--atlas-project <id>` — MongoDB Atlas project ID (fallback: `$ATLAS_PROJECT_ID`)
- `--atlas-host <id>` — Atlas host ID / process ID to query (fallback: list all hosts)
- `--url-latency <regex>` — optional: compute p50/p95/p99 latency from Cloud Logging for URLs matching this regex (e.g. `"/v2/orders/"`)
- `--url-latency-period <hours>` — lookback window for `--url-latency` (default: 24h, max practical: 72h)

## MongoDB Atlas Auth

Always read credentials from environment — NEVER hardcode or prompt for them:
```
ATLAS_PUBLIC_KEY    — Atlas API public key
ATLAS_PRIVATE_KEY   — Atlas API private key
ATLAS_PROJECT_ID    — Atlas project ID (can be overridden by --atlas-project)
```

Use HTTP Digest Auth with these credentials against `https://cloud.mongodb.com/api/atlas/v2`.

## Step-by-step execution

### 1. Resolve config
```bash
GCP_PROJECT=$(gcloud config get-value project 2>/dev/null)

# If multiple GKE clusters exist, ask user which one to target
CLUSTERS=$(gcloud container clusters list --project="$GCP_PROJECT" --format="value(name,location)" 2>/dev/null)
CLUSTER_COUNT=$(echo "$CLUSTERS" | grep -c .)
if [ "$CLUSTER_COUNT" -gt 1 ]; then
  echo "Multiple clusters found:"
  echo "$CLUSTERS"
  # Prompt user: "Which cluster should I use? (name or number)"
  # Wait for user input before proceeding.
  # Once selected, switch context:
  # gcloud container clusters get-credentials <cluster> --region=<region> --project="$GCP_PROJECT"
else
  KUBE_CONTEXT=$(kubectl config current-context 2>/dev/null)
fi
```

### 2. GKE Metrics

> **CRITICAL: `kubectl top` shows CURRENT state only — do NOT use it for weekly/period reports.**
> For any report covering a time range, always use GCP Monitoring REST API (see below).
> `kubectl top` and `kubectl get pods` are only useful for real-time snapshots.

**Node CPU & Memory — historical (GCP Monitoring REST API):**
```bash
ACCESS_TOKEN=$(gcloud auth print-access-token 2>/dev/null)
BASE="https://monitoring.googleapis.com/v3/projects/$GCP_PROJECT/timeSeries"
# START/END must be ISO8601 UTC, e.g. START="2026-03-24T00:00:00Z" END="2026-03-30T23:59:59Z"
# For weekly avg: use alignmentPeriod=604800s (1 week) with ALIGN_MEAN → 1 data point per node = weekly avg
# For hourly max: use alignmentPeriod=3600s with ALIGN_MAX

echo "=== Node CPU (weekly avg per node) ==="
curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "$BASE?filter=metric.type%3D%22kubernetes.io/node/cpu/allocatable_utilization%22%20AND%20resource.labels.cluster_name%3D%22$CLUSTER_NAME%22&interval.startTime=$START&interval.endTime=$END&aggregation.alignmentPeriod=604800s&aggregation.perSeriesAligner=ALIGN_MEAN" \
| python3 -c "
import json, sys
data = json.load(sys.stdin)
results = []
for t in data.get('timeSeries', []):
  node = t['resource']['labels'].get('node_name', 'unknown').split('-')[-1]
  pts = [p['value'].get('doubleValue', 0) for p in t.get('points', [])]
  avg = sum(pts)/len(pts)*100 if pts else 0
  results.append((node, avg))

for node, avg in sorted(results, key=lambda x: -x[1]):
  flag = '✖ CRIT' if avg > 90 else '⚠ WARN' if avg > 70 else 'OK'
  if avg > 50:
    print(f'  {node:10s} avg={avg:5.1f}%  {flag}')
print(f'Total nodes seen: {len(results)}  |  Nodes avg>70%: {sum(1 for _,a in results if a>70)}')
"

echo "=== Node Memory (weekly avg per node) ==="
curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "$BASE?filter=metric.type%3D%22kubernetes.io/node/memory/allocatable_utilization%22%20AND%20resource.labels.cluster_name%3D%22$CLUSTER_NAME%22&interval.startTime=$START&interval.endTime=$END&aggregation.alignmentPeriod=604800s&aggregation.perSeriesAligner=ALIGN_MEAN" \
| python3 -c "
import json, sys
data = json.load(sys.stdin)
results = []
for t in data.get('timeSeries', []):
  node = t['resource']['labels'].get('node_name', 'unknown').split('-')[-1]
  pts = [p['value'].get('doubleValue', 0) for p in t.get('points', [])]
  avg = sum(pts)/len(pts)*100 if pts else 0
  results.append((node, avg))

high = [(n, a) for n, a in results if a >= 70]
print(f'Memory high-water (max avg): {max(results, key=lambda x: x[1])}')
print(f'Nodes avg memory >= 80%: {[n for n,a in results if a >= 80]}')
for node, avg in sorted(high, key=lambda x: -x[1]):
  flag = '✖ CRIT' if avg > 90 else '⚠ WARN'
  print(f'  {node:10s} avg={avg:5.1f}%  {flag}')
"
```

**Node conditions (Ready / pressure flags) — current state only:**
```bash
kubectl get nodes -o custom-columns="NAME:.metadata.name,STATUS:.status.conditions[-1].type,READY:.status.conditions[-1].status" --no-headers 2>/dev/null
```

**Pod restarts — historical delta (GCP Monitoring REST API):**
```bash
# ALIGN_DELTA over the full period gives restarts added within that window (not cumulative).
# Do NOT use kubectl get pods restartCount for period reports — it is cumulative since pod creation.

echo "=== Pod restarts (period delta) ==="
curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "$BASE?filter=metric.type%3D%22kubernetes.io/container/restart_count%22%20AND%20resource.labels.cluster_name%3D%22$CLUSTER_NAME%22%20AND%20resource.labels.namespace_name%3D%22mmenu-prod%22&interval.startTime=$START&interval.endTime=$END&aggregation.alignmentPeriod=604800s&aggregation.perSeriesAligner=ALIGN_DELTA" \
| python3 -c "
import json, sys
data = json.load(sys.stdin)
results = []
for t in data.get('timeSeries', []):
  pod = t['resource']['labels'].get('pod_name', '')
  container = t['resource']['labels'].get('container_name', '')
  total = 0
  for p in t.get('points', []):
    v = p.get('value', {})
    total += int(v.get('int64Value', v.get('doubleValue', 0) or 0))
  if total > 3:
    results.append((total, pod, container))

results.sort(reverse=True)
for total, pod, container in results:
  status = '✖ CRIT' if total > 10 else '⚠ WARN'
  print(f'  {status} | restarts={total:3d} | {pod} | {container}')
"
```

**HPA status — current state (kubectl):**
```bash
# For current ratios. Use --sort-by or -o custom-columns to avoid JSON boolean parsing issues.
kubectl get hpa -n mmenu-prod \
  -o custom-columns="NAME:.metadata.name,CURRENT:.status.currentReplicas,MAX:.spec.maxReplicas" \
  --no-headers 2>/dev/null | awk '{
    ratio = ($2/$3)*100
    flag = (ratio > 80) ? "⚠ WARN" : "OK"
    printf "  %-40s current=%3d / max=%3d  ratio=%5.1f%%  %s\n", $1, $2, $3, ratio, flag
  }'
```

**Ingress / Load Balancer — 5xx error rate (GCP Monitoring REST API):**
```bash
# NEVER use Cloud Logging --limit sampling for error rates.
# Cloud Logging --limit=N caps results and gives a misleading percentage
# (e.g. --limit=1000 out of millions of requests → fake 20% rate).
# Always use loadbalancing.googleapis.com/https/request_count from Monitoring API.

echo "=== 5xx error rate (daily, from Monitoring API) ==="
# 5xx counts
curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "$BASE?filter=metric.type%3D%22loadbalancing.googleapis.com%2Fhttps%2Frequest_count%22%20AND%20metric.labels.response_code_class%3D%22500%22&interval.startTime=$START&interval.endTime=$END&aggregation.alignmentPeriod=86400s&aggregation.perSeriesAligner=ALIGN_SUM&aggregation.crossSeriesReducer=REDUCE_SUM" \
| python3 -c "
import json, sys
from collections import defaultdict
data = json.load(sys.stdin)
by_day = defaultdict(int)
for t in data.get('timeSeries', []):
  for p in t.get('points', []):
    v = p['value']
    val = int(v.get('int64Value', v.get('doubleValue', 0) or 0))
    ts = p['interval']['startTime'][:10]
    by_day[ts] += val
total = sum(by_day.values())
for ts in sorted(by_day):
  print(f'  5xx {ts}: {by_day[ts]:,}')
print(f'  5xx TOTAL: {total:,}')
" > /tmp/5xx_data.txt

# Total request counts
curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
  "$BASE?filter=metric.type%3D%22loadbalancing.googleapis.com%2Fhttps%2Frequest_count%22&interval.startTime=$START&interval.endTime=$END&aggregation.alignmentPeriod=86400s&aggregation.perSeriesAligner=ALIGN_SUM&aggregation.crossSeriesReducer=REDUCE_SUM" \
| python3 -c "
import json, sys
from collections import defaultdict
data = json.load(sys.stdin)
by_day = defaultdict(int)
for t in data.get('timeSeries', []):
  for p in t.get('points', []):
    v = p['value']
    val = int(v.get('int64Value', v.get('doubleValue', 0) or 0))
    ts = p['interval']['startTime'][:10]
    by_day[ts] += val
total = sum(by_day.values())
for ts in sorted(by_day):
  print(f'  tot {ts}: {by_day[ts]:,}')
print(f'  tot TOTAL: {total:,}')
" > /tmp/total_data.txt

# Compute rates
python3 -c "
import re
fivex = {}
total = {}
for line in open('/tmp/5xx_data.txt'):
  m = re.match(r'  5xx\s+(\S+):\s+([\d,]+)', line)
  if m: fivex[m.group(1)] = int(m.group(2).replace(',',''))
for line in open('/tmp/total_data.txt'):
  m = re.match(r'  tot\s+(\S+):\s+([\d,]+)', line)
  if m: total[m.group(1)] = int(m.group(2).replace(',',''))
for day in sorted(total):
  t = total[day]; e = fivex.get(day, 0)
  rate = e/t*100 if t else 0
  flag = ' ✖ CRIT' if rate > 5 else ' ⚠ WARN' if rate > 1 else ''
  print(f'  {day}: {e:,} / {t:,} = {rate:.4f}%{flag}')
tot5 = sum(fivex.values()); totall = sum(total.values())
print(f'  WEEKLY: {tot5:,} / {totall:,} = {tot5/totall*100:.4f}%')
"

# For spike investigation: break down a specific day by hour
# SPIKE_DAY="2026-03-28"
# curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
#   "$BASE?filter=metric.type%3D%22loadbalancing.googleapis.com%2Fhttps%2Frequest_count%22%20AND%20metric.labels.response_code_class%3D%22500%22&interval.startTime=${SPIKE_DAY}T00:00:00Z&interval.endTime=${SPIKE_DAY}T23:59:59Z&aggregation.alignmentPeriod=3600s&aggregation.perSeriesAligner=ALIGN_SUM&aggregation.crossSeriesReducer=REDUCE_SUM" \
# | python3 -c "..."
```

> **Note:** `gcloud monitoring read` / `gcloud monitoring metrics-descriptors` are **not available** in this environment. Use the GCP Monitoring REST API or Cloud Logging instead.

### 3. Memorystore (Redis) Metrics

> **Note:** `gcloud monitoring read` is **not available**. Use the GCP Monitoring REST API directly with a Bearer token.

```bash
# Auto-discover Redis instance in the project region
REDIS_REGION="${REDIS_REGION:-asia-southeast1}"
gcloud redis instances list --project="$GCP_PROJECT" --region="$REDIS_REGION" \
  --format="table(name,memorySizeGb,state,currentLocationId)" 2>/dev/null
# Set REDIS_INSTANCE to the instance name found above

# Use value() format to avoid JSON boolean parsing issues (gcloud JSON uses lowercase true/false
# which is valid JSON, but piping into a python3 heredoc can cause NameError on 'true').
# Prefer --format="value(...)" for simple fields.
gcloud redis instances describe "$REDIS_INSTANCE" \
  --region="$REDIS_REGION" \
  --project="$GCP_PROJECT" \
  --format="value(memorySizeGb,redisVersion,state)" 2>/dev/null

# Use GCP Monitoring REST API (requires gcloud auth)
ACCESS_TOKEN=$(gcloud auth print-access-token 2>/dev/null)
PROJECT="$GCP_PROJECT"
NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)
WEEK_AGO=$(date -u -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ)
BASE="https://monitoring.googleapis.com/v3/projects/$PROJECT/timeSeries"
ALIGN="aggregation.alignmentPeriod=3600s"

fetch_metric() {
  local METRIC="$1" ALIGNER="$2"
  curl -s -H "Authorization: Bearer $ACCESS_TOKEN" \
    "$BASE?filter=metric.type%3D%22$METRIC%22&interval.startTime=$WEEK_AGO&interval.endTime=$NOW&$ALIGN&aggregation.perSeriesAligner=$ALIGNER"
}

# Memory usage ratio (most critical) — WARN >70%, CRIT >85%
# IMPORTANT: If the Redis instance was resized during the report period, the usage_ratio
# reflects the old capacity before the resize and will appear falsely high.
# Always cross-check with the absolute memory/usage metric (bytes) and note the resize date.
# Set $START to the day AFTER any resize to get accurate post-upgrade ratios.
echo "=== memory/usage_ratio ==="
fetch_metric "redis.googleapis.com/stats/memory/usage_ratio" "ALIGN_MEAN" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t in data.get('timeSeries', []):
  pts = t.get('points', [])
  if pts:
    vals = [p['value'].get('doubleValue', 0) for p in pts]
    print(f'memory_usage_ratio: latest={vals[0]*100:.1f}%  max={max(vals)*100:.1f}%  avg={sum(vals)/len(vals)*100:.1f}%')
"

# Always also fetch absolute bytes to cross-validate ratio
echo "=== memory/usage (absolute) ==="
fetch_metric "redis.googleapis.com/stats/memory/usage" "ALIGN_MEAN" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t in data.get('timeSeries', []):
  pts = t.get('points', [])
  if pts:
    vals = [p['value'].get('doubleValue', p['value'].get('int64Value', 0)) for p in pts]
    print(f'memory_usage_bytes: latest={vals[0]/1024**3:.2f}GB  max={max(vals)/1024**3:.2f}GB  avg={sum(vals)/len(vals)/1024**3:.2f}GB')
" 2>/dev/null || echo "SKIP: memory/usage metric not available"

# Cache hit ratio — WARN <85%, CRIT <70%
echo "=== cache_hit_ratio ==="
fetch_metric "redis.googleapis.com/stats/cache_hit_ratio" "ALIGN_MEAN" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t in data.get('timeSeries', []):
  pts = t.get('points', [])
  if pts:
    vals = [p['value'].get('doubleValue', 0) for p in pts]
    print(f'cache_hit_ratio: latest={vals[0]*100:.1f}%  min={min(vals)*100:.1f}%  avg={sum(vals)/len(vals)*100:.1f}%')
"

# Evicted keys — WARN if any sustained > 0
echo "=== evicted_keys ==="
fetch_metric "redis.googleapis.com/stats/evicted_keys" "ALIGN_RATE" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t in data.get('timeSeries', []):
  pts = t.get('points', [])
  if pts:
    vals = [p['value'].get('doubleValue', 0) for p in pts]
    non_zero = [v for v in vals if v > 0]
    print(f'evicted_keys/s: max={max(vals):.3f}  non_zero_periods={len(non_zero)}')
"

# Connected clients (peak)
echo "=== connected_clients ==="
fetch_metric "redis.googleapis.com/clients/connected" "ALIGN_MAX" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t in data.get('timeSeries', []):
  pts = t.get('points', [])
  if pts:
    vals = [int(p['value'].get('int64Value', p['value'].get('doubleValue', 0))) for p in pts]
    print(f'connected_clients: max={max(vals)}  avg={sum(vals)//len(vals)}')
"

# Rejected connections — WARN/CRIT if any
echo "=== rejected_connections ==="
fetch_metric "redis.googleapis.com/stats/rejected_connections" "ALIGN_SUM" | python3 -c "
import json, sys
data = json.load(sys.stdin)
ts = data.get('timeSeries', [])
if not ts:
  print('rejected_connections: 0')
else:
  for t in ts:
    pts = t.get('points', [])
    if pts:
      vals = [int(p['value'].get('int64Value', p['value'].get('doubleValue', 0))) for p in pts]
      print(f'rejected_connections: total_7d={sum(vals)}  max_per_hour={max(vals)}')
"

### 4. MongoDB Atlas Metrics

> **Critical notes on Atlas REST API:**
> - Use **repeated `&m=`** query params, NOT comma-separated. A single `m=A,B` is treated as one invalid metric name.
> - Metric names differ from the Atlas UI docs. Verified working names listed below.
> - `REPLICATION_LAG` is **invalid** — use `OPLOG_SLAVE_LAG_MASTER_TIME` for actual secondary lag (valid on secondaries only, not primary).
> - `OPLOG_MASTER_LAG_TIME_DIFF` is the oplog window coverage difference — it is **NOT** replication lag. Ignore it.
> - CPU metric: use `PROCESS_NORMALIZED_CPU_USER` (not `SYSTEM_CPU_PERCENT`).
> - Cache metrics: `CACHE_DIRTY_BYTES` and `CACHE_USED_BYTES` (not `CACHE_USAGE_DIRTY/USED`).
> - Opcounter metrics: `OPCOUNTER_QUERY/INSERT/UPDATE/DELETE` (no trailing S, not `OPCOUNTERS_*`).
> - `CONNECTIONS_PERCENT` and `DISK_PARTITION_IOPS_READ/WRITE` do **not exist** — compute connection % manually from CONNECTIONS ÷ cluster max.

```bash
ATLAS_BASE="https://cloud.mongodb.com/api/atlas/v2"
ATLAS_GROUP="${ATLAS_PROJECT_ID}"
PUB="${ATLAS_PUBLIC_KEY}"
PRIV="${ATLAS_PRIVATE_KEY}"

# List all processes (hosts)
curl -s --digest -u "$PUB:$PRIV" \
  -H "Accept: application/vnd.atlas.2023-01-01+json" \
  "$ATLAS_BASE/groups/$ATLAS_GROUP/processes" | \
  python3 -c "
import json, sys
data = json.load(sys.stdin)
for p in data.get('results', []):
  print(p['id'], p.get('replicaSetName',''), p['typeName'])
"

# Get cluster tier (to compute connection % manually)
curl -s --digest -u "$PUB:$PRIV" \
  -H "Accept: application/vnd.atlas.2023-01-01+json" \
  "$ATLAS_BASE/groups/$ATLAS_GROUP/clusters" | \
  python3 -c "
import json, sys
data = json.load(sys.stdin)
for r in data.get('results', []):
  print('Cluster:', r.get('name'), '| Tier:', r.get('providerSettings',{}).get('instanceSizeName',''), '| State:', r.get('stateName'))
"
# M50 = 16,000 max connections. M40 = 6,000. M30 = 3,000.

# For each host, fetch metrics using repeated &m= params (1h granularity, 7-day period)
# Valid metric names (verified):
#   CONNECTIONS, PROCESS_NORMALIZED_CPU_USER,
#   SYSTEM_MEMORY_USED, SYSTEM_MEMORY_AVAILABLE,
#   CACHE_DIRTY_BYTES, CACHE_USED_BYTES,
#   GLOBAL_LOCK_CURRENT_QUEUE_READERS, GLOBAL_LOCK_CURRENT_QUEUE_WRITERS,
#   OP_EXECUTION_TIME_READS, OP_EXECUTION_TIME_WRITES,
#   OPCOUNTER_QUERY, OPCOUNTER_INSERT, OPCOUNTER_UPDATE, OPCOUNTER_DELETE

fetch_atlas_host() {
  local HOST="$1"
  curl -s --digest -u "$PUB:$PRIV" \
    -H "Accept: application/vnd.atlas.2023-01-01+json" \
    "$ATLAS_BASE/groups/$ATLAS_GROUP/processes/$HOST/measurements?granularity=PT1H&period=P7D\
&m=CONNECTIONS&m=PROCESS_NORMALIZED_CPU_USER\
&m=SYSTEM_MEMORY_USED&m=SYSTEM_MEMORY_AVAILABLE\
&m=CACHE_DIRTY_BYTES&m=CACHE_USED_BYTES\
&m=GLOBAL_LOCK_CURRENT_QUEUE_READERS&m=GLOBAL_LOCK_CURRENT_QUEUE_WRITERS\
&m=OP_EXECUTION_TIME_READS&m=OP_EXECUTION_TIME_WRITES\
&m=OPCOUNTER_QUERY&m=OPCOUNTER_INSERT&m=OPCOUNTER_UPDATE&m=OPCOUNTER_DELETE" | \
    python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data:
  print('ERROR:', data.get('detail'))
else:
  for m in data.get('measurements', []):
    name = m['name']
    pts = [p for p in m.get('dataPoints', []) if p.get('value') is not None]
    if pts:
      vals = [p['value'] for p in pts]
      unit = m.get('units', '')
      print(f'  {name}: latest={vals[-1]:.2f}  max={max(vals):.2f}  avg={sum(vals)/len(vals):.2f}  unit={unit}')
    else:
      print(f'  {name}: no data')
"
}

# For secondaries only: fetch replication lag
fetch_atlas_replication_lag() {
  local HOST="$1"
  curl -s --digest -u "$PUB:$PRIV" \
    -H "Accept: application/vnd.atlas.2023-01-01+json" \
    "$ATLAS_BASE/groups/$ATLAS_GROUP/processes/$HOST/measurements?granularity=PT5M&period=PT1H\
&m=OPLOG_SLAVE_LAG_MASTER_TIME" | \
    python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'error' in data:
  print('  REPLICATION_LAG: ERROR -', data.get('detail'))
else:
  for m in data.get('measurements', []):
    pts = [p for p in m.get('dataPoints', []) if p.get('value') is not None]
    if pts:
      vals = [p['value'] for p in pts]
      print(f'  OPLOG_SLAVE_LAG_MASTER_TIME (actual lag): latest={vals[-1]:.2f}s  max={max(vals):.2f}s')
    else:
      print('  REPLICATION_LAG: no data')
"
}

# Iterate over all hosts
# Example (replace with actual host IDs from process list above):
# PRIMARY="atlas-XXXXX-shard-00-02.YYYY.mongodb.net:27017"
# SEC0="atlas-XXXXX-shard-00-00.YYYY.mongodb.net:27017"
# SEC1="atlas-XXXXX-shard-00-01.YYYY.mongodb.net:27017"
#
# echo "=== PRIMARY: $PRIMARY ==="; fetch_atlas_host "$PRIMARY"
# echo "=== SECONDARY-00: $SEC0 ==="; fetch_atlas_host "$SEC0"; fetch_atlas_replication_lag "$SEC0"
# echo "=== SECONDARY-01: $SEC1 ==="; fetch_atlas_host "$SEC1"; fetch_atlas_replication_lag "$SEC1"
```

### 5. Per-URL Latency (optional — only if `--url-latency` is specified)

Cloud LB aggregate metrics do not expose per-URL percentiles. Use Cloud Logging instead:

```bash
URL_PATTERN="${URL_PATTERN:-/api/}"   # from --url-latency
PERIOD="${URL_LATENCY_PERIOD:-24}h"

gcloud logging read \
  "resource.type=\"http_load_balancer\" AND httpRequest.requestUrl=~\"${URL_PATTERN}\"" \
  --project="$GCP_PROJECT" \
  --freshness="$PERIOD" \
  --format="value(httpRequest.latency,httpRequest.requestUrl,httpRequest.status)" \
  --limit=20000 2>/dev/null | python3 -c "
import sys, re
from collections import defaultdict

# Group latencies by URL prefix (first 2 path segments)
groups = defaultdict(list)
for line in sys.stdin:
  parts = line.strip().split('\t')
  if len(parts) < 2: continue
  lat_str, url = parts[0], parts[1]
  status = parts[2] if len(parts) > 2 else ''
  try:
    lat = float(lat_str.rstrip('s'))
  except:
    continue
  # Normalize URL: strip query string, collapse IDs
  path = url.split('?')[0]
  path = re.sub(r'https?://[^/]+', '', path)
  path = re.sub(r'/[0-9a-f]{24}', '/{id}', path)
  path = re.sub(r'/\d+', '/{n}', path)
  segments = path.split('/')
  key = '/'.join(segments[:4])  # keep first 3 path segments
  groups[key].append(lat)

for key, vals in sorted(groups.items(), key=lambda x: -len(x[1])):
  vals.sort()
  n = len(vals)
  p50 = vals[int(n * 0.50)]
  p95 = vals[int(n * 0.95)]
  p99 = vals[int(n * 0.99)]
  print(f'{key:50s}  count={n:6d}  p50={p50*1000:.0f}ms  p95={p95*1000:.0f}ms  p99={p99*1000:.0f}ms')
"
```

**Caveats:**
- `--limit 20000` caps samples; high-traffic endpoints may be undersampled. Use shorter `--freshness` to compensate.
- Latency here is total LB latency (client→LB→backend→LB→client), not pure backend latency.
- For true per-route percentiles at scale, instrument the app with Prometheus histograms + GKE Managed Prometheus.

Add a `[URL LATENCY]` section to the report output when this flag is used:
```
[URL LATENCY]  pattern="<regex>"  period=<Xh>  samples=<N>
  /v2/orders/{id}                  count=  4821  p50=  82ms  p95= 312ms  p99= 891ms
  /v2/printer/{id}/getPrinterJob   count=  1203  p50= 143ms  p95=1840ms  p99=4200ms  ⚠ p95>1s
  ...
```
Flag any route where p95 > 1000ms as ⚠ WARN or p95 > 2000ms as ✖ CRIT.

### 6. Threshold evaluation & report

After collecting all data, produce a structured report in this format:

```
══════════════════════════════════════════════════════
  INFRASTRUCTURE HEALTH REPORT  —  <timestamp>
══════════════════════════════════════════════════════

[GKE]
  Nodes
    <node>  CPU: X%  Memory: X%  Status: OK/WARN/CRIT
  Pods
    <namespace>/<pod>  Restarts: N  Status: OK/WARN/CRIT
  Ingress
    5xx rate: X req/s  P95 latency: Xms  Status: OK/WARN/CRIT

[REDIS]
  Memory usage: X%     → OK / ⚠ WARN / ✖ CRIT
  Cache hit ratio: X%  → OK / ⚠ WARN / ✖ CRIT
  Evicted keys: N/s    → OK / ⚠ WARN
  Rejected conns: N    → OK / ✖ CRIT
  Commands/s: N

[MONGODB ATLAS]
  <host> (<role>)
    CPU: X%            → OK / ⚠ WARN / ✖ CRIT
    Memory: X%         → OK / ⚠ WARN / ✖ CRIT
    Connections: N (X%)→ OK / ⚠ WARN / ✖ CRIT
    Replication lag: Xs→ OK / ⚠ WARN / ✖ CRIT
    Disk IOPS R/W: N/N
    Lock queue R/W: N/N→ OK / ⚠ WARN / ✖ CRIT
    Op latency R/W: Xms

──────────────────────────────────────────────────────
VIOLATIONS SUMMARY
  ✖ CRITICAL: <list>
  ⚠ WARNING:  <list>
══════════════════════════════════════════════════════
```

## Alert Thresholds

### GKE
| Metric | WARN | CRIT |
|--------|------|------|
| Node CPU allocatable | >70% | >90% |
| Node Memory allocatable | >80% | >90% |
| Container Memory limit | >85% | >95% |
| Container restarts | >3/hour | >10/hour |
| Ingress 5xx rate | >1% | >5% |
| Ingress P95 latency | >500ms | >2000ms |

### Redis
| Metric | WARN | CRIT |
|--------|------|------|
| Memory usage ratio | >70% | >85% |
| Cache hit ratio | <85% | <70% |
| Evicted keys/s | >0 sustained | any spike |
| Rejected connections | >0 | any |

### MongoDB Atlas
| Metric | WARN | CRIT |
|--------|------|------|
| CPU | >70% | >85% |
| Memory | >80% | >90% |
| Connections % | >60% | >80% |
| Replication lag | >10s | >60s |
| Disk utilization | >75% | >90% |
| Lock queue (R or W) | >10 | >50 |

## Error handling

- If a `gcloud` command fails (no permissions, metric not found), print `SKIP: <reason>` and continue.
- If `kubectl` context is not set, warn and skip GKE section.
- If Atlas env vars are missing (`ATLAS_PUBLIC_KEY`, `ATLAS_PRIVATE_KEY`, `ATLAS_PROJECT_ID`), print error and skip Atlas section.
- Never exit early — always produce a partial report with available data.

## Notes

- Run commands sequentially; do not parallelize shell calls as output order matters for the report.
- When a metric returns multiple time-series (e.g., per-node or per-container), report each one.
- For Atlas, iterate over all processes returned by the list call unless `--atlas-host` is specified.
- Highlight the VIOLATIONS SUMMARY at the end regardless of whether all sections were collected.
