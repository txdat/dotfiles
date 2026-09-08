# ai-shared setup

## claude

Symlink `~/.claude/CLAUDE.md` → `~/.dotfiles/.ai-shared/AGENTS.md`

**agents** — create `~/.claude/agents/<name>.md` per [template](#claude-template) and [references](#references)

**skills** — create `~/.claude/skills/<name>/SKILL.md` per [template](#claude-template) and [references](#references)

**marketplace** — add local marketplace (`~/.dotfiles/.claude/marketplace/`) via `claude plugin marketplace add <path>`, install plugins via `/plugin`

### claude template

agent

```
---
name: <name>
description: <description>
model: <claude model>
effort: <effort>
---

Read <md file> and follow all instructions exactly.
```

skill

```
---
name: <name>
description: <description>
model: <claude model>
effort: <effort>
---

Read <md file> and follow all instructions exactly.
```

## chatgpt/codex

Symlink `~/.codex/CODEX.md` → `~/.dotfiles/.ai-shared/AGENTS.md`

`CODEX.md` is the only setup-managed symlink. Do not remove or modify other symlinks in `~/.codex`: Codex creates them for its runtime under `packages/` and `tmp/`.

**agents** — create `~/.codex/agents/<name>.toml` per [template](#chatgpt-template). Use the matching row in [references](#references) for its name, description, and effort, then map its model through the [model mapping](#model-mapping) table.

**skills** — create `~/.codex/skills/<name>/SKILL.md` per [template](#chatgpt-template). Use the matching row in [references](#references) for its name, description, and effort, then map its model through the [model mapping](#model-mapping) table.

### chatgpt template

agent

```toml
name = "<name>"
description = "<description>"
model = "<chatgpt model>"
model_reasoning_effort = "<effort>"

developer_instructions = """
Read <md file> and follow all instructions exactly.
"""
```

skill

```
---
name: <name>
description: <description>
model: <chatgpt model>
effort: <effort>
---

Read <md file> and follow all instructions exactly.
```

## gemini/antigravity

Symlink `~/.gemini/config/GEMINI.md` → `~/.dotfiles/.ai-shared/AGENTS.md` (and `~/.gemini/GEMINI.md`)

**agents** — create `~/.gemini/config/agents/<name>/agent.md`, or register path in `~/.gemini/config/agents.json`; see [template](#gemini-template), [references](#references), and [model mapping](#model-mapping) to map model

**skills** — create `~/.gemini/config/skills/<name>/SKILL.md`, or register path in `~/.gemini/config/skills.json`; see [template](#gemini-template), [references](#references), and [model mapping](#model-mapping) to map model

**hooks** — register lifecycle hooks in `~/.gemini/config/hooks.json` (e.g., `gate-check` command for `PreToolUse`)

### gemini template

agent

```
---
name: <name>
description: <description>
model: <gemini model>
effort: <effort>
---

Read <md file> and follow all instructions exactly.
```

skill

```
---
name: <name>
description: <description>
model: <gemini model>
effort: <effort>
---

Read <md file> and follow all instructions exactly.
```

## pi

Symlink `~/.pi/agent/AGENTS.md` → `~/.dotfiles/.ai-shared/AGENTS.md`

Symlink `~/.pi/agent/extensions` → `~/.dotfiles/.pi/agent/extensions`

Symlink `~/.pi/agent/themes` → `~/.dotfiles/.pi/agent/themes`

**skills** — reuses Claude skills; set `"skills": ["~/.claude/skills"]` in `settings.json`

**mcp** — reuses Claude mcp; set `"imports": ["claude-code"]` in `mcp.json`

## references

### model mapping

| claude | chatgpt | gemini |
| ------ | ------- | ------ |
| haiku | gpt-5.6-luna | flash |
| sonnet | gpt-5.6-terra | flash |
| opus | gpt-5.6-sol | pro |

### agents

| agent | description | md file | effort | model |
| ----- | ----------- | ------- | ------ | ----- |
| architecture-strategist | Use ONLY when features CREATE or CHANGE system architecture. For: new layers, communication patterns, tech stack, cross-service integrations, scalability. NOT for regular features. Also review-system's delegated reviewer. | agents/architecture-strategist.md | high | opus |
| code-explorer | Fast codebase exploration. Find files by pattern, search keywords, answer codebase questions. Specify thoroughness: 'quick' (1–2 searches), 'medium' (default), 'very thorough' (exhaustive). | agents/code-explorer.md | medium | haiku |
| code-quality-auditor | review-code's delegated reviewer when the same session produced the diff, or an explicitly user-requested audit; at most one per request. Never auto-invoke from BLUE, feature completion, or PR preparation. | agents/code-quality-auditor.md | high | sonnet |
| feature-planner | Business features and regular development: breakdown, API design, implementation strategies, refactoring. NOT for architecture changes (use architecture-strategist). Also review-feature's delegated reviewer. | agents/feature-planner.md | medium | opus |
| junior-engineer | Fast executor. STRICTLY follows plans and existing patterns. NO reinventing, NO design decisions. Pure implementation. | agents/junior-engineer.md | medium | haiku |
| senior-engineer | Accurate executor for complex and critical tasks — including concurrency, security-sensitive, data-integrity and performance-critical work. Follows plans strictly, copies patterns, reasons from invariants and failure modes on critical steps. | agents/senior-engineer.md | medium | sonnet |

### skills

#### swe

| skill | description | md file | effort | model |
| ----- | ----------- | ------- | ------ | ----- |
| dev-create-issue | Create a standalone GitHub issue with a specific problem, expected outcome, and requested metadata. Use for unplanned issue capture; use dev-design-feature for implementation-plan-linked issues. | skills/dev/create-issue.md | medium | haiku |
| dev-create-pr | Publish reviewed plan work as draft or ready pull request(s), verify committed scope, archive the plan safely, and clean up its worktree. | skills/dev/create-pr.md | medium | haiku |
| dev-design-feature | Design an issue-backed feature, fix, or refactor plan before implementation, including scope, test cases, impact, ordered steps, and provisional PR slicing. | skills/dev/design-feature.md | medium | opus |
| dev-design-infra | Design an infra/devops runbook for migrations, shutdowns, deployments, DNS cutover, IaC changes, database operations, or maintenance — with live-state verification, phased execution, rollback gates, and destruction checklists. | skills/dev/design-infra.md | high | sonnet |
| dev-design-system | Design cross-cutting architecture changes such as new communication patterns, service boundaries, or integrations, with options, contracts, migration, rollback, and decomposition. | skills/dev/design-system.md | high | opus |
| dev-execute-feature | Execute an approved feature/fix/refactor plan in its worktree with per-slice RED→GREEN→BLUE commits, coverage, dependent checks, and locked-scope controls. | skills/dev/execute-feature.md | medium | sonnet |
| dev-explore | Read-only exploration of a codebase area to identify entry points, key files, data flow, established patterns, gotchas, and planning questions. | skills/dev/explore.md | medium | haiku |
| dev-fix-bug | Diagnose an issue-backed bug from ranked hypotheses and evidence, then optionally apply a minimal RED-first fix with coverage, caller verification, and review handoff. | skills/dev/fix-bug.md | high | sonnet |
| dev-frame-goal | Frame a raw requirement into one or more confirmed goals before design: split a too-broad goal along capability, deployment, and failure-domain boundaries, question ambiguity with competing examples, and push back for the user's confirmation. | skills/dev/frame-goal.md | medium | opus |
| dev-review-code | Review implemented plan changes for TDD proof, independent test results, correctness, security, architecture, scope, hygiene, and final PR slicing before create-pr. | skills/dev/review-code.md | high | sonnet |
| dev-review-feature | Review a planning-stage feature/fix/refactor plan for approach, system fit, test completeness, impact, scope, and independently mergeable PR slices before human approval. | skills/dev/review-feature.md | medium | opus |
| dev-review-infra | Review an infra/devops runbook against live state with read-only commands: phase ordering, rollback safety, DNS/traffic cutover sequencing, IaC completeness, and CI/CD coverage. | skills/dev/review-infra.md | high | sonnet |
| dev-review-system | Review an architecture design for measurable outcomes, viable alternatives, boundary contracts, failure modes, migration and rollback safety, and dependency-ordered decomposition. | skills/dev/review-system.md | high | opus |
| dev-recap | Session lessons and workflow improvement proposals from a plan-based session. | skills/dev/recap.md | — | — |
| dev-ship-feature | Orchestrate the gated end-to-end delivery cycle—explore, design, plan review, human approval, execution, code review, and pull request—with resumable phase detection. | skills/dev/ship-feature.md | — | — |

#### sre

| skill | description | md file | effort | model |
| ----- | ----------- | ------- | ------ | ----- |
| gke-inspect-incident | Investigate GKE incidents: pod restart cascades, 503/504 errors, CrashLoopBackOff, pods stuck Pending, node autoscaling failures, and network/VPC problems. All commands are read-only. | skills/gke/inspect-incident.md | — | — |

#### ielts

| skill | description | md file | effort | model |
| ----- | ----------- | ------- | ------ | ----- |
| ielts-listening | Analyze IELTS listening answers against scripts and available evidence. Guide replay and focused drills; distinguish supported diagnoses from hypotheses. | skills/ielts/listening.md | — | — |
| ielts-mock | Record full or partial IELTS practice and exam results, preserve each score's provenance, calculate an overall only from four known components, and archive safely. | skills/ielts/mock.md | — | — |
| ielts-reading | Diagnose IELTS reading errors: locate passage evidence, extract synonym pairs, show correct reasoning chain. Covers T/F/NG, Matching Headings, and guided practice. | skills/ielts/reading.md | — | — |
| ielts-speaking | Prepare IELTS speaking topics and review transcript language. Transcript-only feedback cannot establish pronunciation, full fluency, or an overall Speaking band. | skills/ielts/speaking.md | — | — |
| ielts-writing | Review IELTS Academic Task 1/2 responses, analyze prompts, and generate practice tasks. Give evidence-based coaching estimates and annotated revisions. | skills/ielts/writing.md | — | — |

#### misc

| skill | description | md file | effort | model |
| ----- | ----------- | ------- | ------ | ----- |
| handoff | Write or read a session handoff snapshot (Goal, Current State, Current Plan, Blockers, Remaining Work) so a fresh session can continue without the old conversation. | skills/handoff.md | — | — |
