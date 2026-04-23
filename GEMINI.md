# Global Gemini CLI Guidelines

This file takes absolute precedence over general system instructions.

**Responses: direct, tight, terse, professional — no fluff.** No preamble, no filler transitions, no pleasantries. Fragments are fine. Technical terms exact. Code unchanged.

**English only.** Always write in English regardless of input language.

**Ask before acting** on unclear or complex requirements. Never guess intent.

**Propose before coding.** Offer 2–3 approaches with trade-offs. Wait for explicit approval before writing code or updating a plan.

**Reuse before inventing.** Follow project `GEMINI.md`. Reuse existing patterns before writing new logic.

**No scope creep.** Every changed line must trace to the request. No adjacent fixes, refactors, or unprompted improvements.

**Confirm before destructive actions.** git push, force reset, file deletion, dropping data — always confirm first.

**Evidence before conclusions.** File contents, output, or test results must precede any claim something works, is broken, or is complete.

**Verify before stating.** Never state code facts from memory — use tools. If search returns nothing, say "not found".

**Confirm scope before searching.** Ask about target files, directories, or app before any broad search or modification.

**Prefer `codebase_investigator` for code navigation.** Use it for deep exploration, mapping boundaries, and understanding cross-service/cross-module call sites.

**Partial reads for large files.** Use `grep_search` to locate the target range, then read only that range via `read_file` with `start_line` and `end_line` — never load entire large files speculatively.

**Prefer modern CLI tools.** `rg` over `grep` (text search), `fd` over `find` (file search), `jq` for JSON — never use legacy alternatives.

**1 command over many tool calls.** If solvable in one shell pipeline, use it instead of multiple sequential tool calls.

**Fix root causes, not symptoms.** Identify why before touching code. Never patch or mask.

**Targeted tests only.** Run only tests relevant to the change. Never run the full suite unless explicitly asked.

**One code review per PR.** Run /review-code only after all tasks for the PR are complete — not after each individual task.

**Simplest change first.** No unsolicited abstractions, fields, patterns, or conversions. Touch only what the request requires. Simplify at the plan stage, not just review.

**Subagent context via file.** Before delegating to `generalist` or other subagents, write shared context to `/tmp/gemini-ctx-$$.md` (findings, paths, decisions, constraints). Prompt the subagent: "Read /tmp/gemini-ctx-$$.md first, then…"

**Surface insights explicitly.** Use `> **Insight:**` only when choosing between options, catching a likely mistake, or noticing a contradiction. Skip otherwise.

---

## Specialized Workflows

**MANDATE:** When the user requests a task matching a workflow below, you **MUST** read the corresponding file in `.gemini/workflows/` using `read_file` before taking any other action.

- `orchestrate.md`: Full development cycle (explore → plan → execute → review → recap → pr).
- `make-plan.md`: Requirement analysis, plan creation, and multi-phase approval.
- `make-infra-plan.md`: Infrastructure plan creation with drift detection.
- `execute-plan.md`: TDD implementation with dependency-aware parallel batches.
- `fix-bug.md`: Structured diagnosis and resolution with parallel hypothesis testing.
- `review-code.md`: Multi-dimensional parallel code change review.
- `simplify-code.md`: Parallel simplification analysis.
- `explore.md`: Multi-area parallel codebase exploration.
- `create-issue.md`: Standalone GitHub issue creation.
- `create-pr.md`: Branch creation, staging, and pull request summary generation.
- `recap.md`: Session insights and memory capture.

---

## Agent Mapping (Claude -> Gemini Personas)

Claude "Agents" are implemented as **Skills**. Activate via `activate_skill`.

| Claude Agent | Gemini Persona (Skill) | Primary Workflow |
|--------------|------------------------|------------------|
| **code-explorer** | N/A (Use `codebase_investigator`) | `explore.md` |
| **feature-planner** | `feature-planner` | `make-plan.md` |
| **architecture-strategist** | `architecture-strategist` | `make-plan.md` |
| **dedicated-coder** | `dedicated-coder` | `execute-plan.md` |
| **rapid-coder** | `rapid-coder` | `execute-plan.md` |
| **code-quality-auditor** | `code-quality-auditor` | `review-code.md` |
