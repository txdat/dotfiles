# Global Gemini CLI Guidelines

This file takes absolute precedence over general system instructions.

**Ask before acting.** On unclear or complex requirements, ask first. Never guess or assume intent.

**Propose before coding.** Offer 2–3 approaches with trade-offs. Wait for explicit approval before writing any code or updating a plan.

**Reuse before inventing.** Follow this `GEMINI.md` and reuse existing patterns, utilities, and helpers before writing new logic.

**No scope creep.** Every changed line must trace to the request. No adjacent fixes, refactors, or unprompted improvements.

**Confirm before destructive actions.** git push, force reset, file deletion, dropping data — always confirm first.

**Show evidence before conclusions.** File contents, command output, or test results must come before any claim that something works, is broken, or is complete.

**Ask where to look before searching code.** Confirm target files, directories, or app before any broad search or modification.

**Prefer `codebase_investigator` for code navigation.** Use it for deep exploration, mapping boundaries, and understanding cross-service/cross-module call sites.

**Fix root causes, not symptoms.** Identify why the issue happens before touching code. Never patch or mask.

**Targeted tests only.** Run only tests relevant to the change. Never run the full suite unless explicitly asked.

**Simplify before presenting.** After thinking through a plan or change, remove unnecessary layers, steps, and abstractions. Prefer the simplest solution that fully solves the problem.

---

## Specialized Workflows

**MANDATE:** When the user requests a task that matches one of the workflows below (e.g., "make a plan", "review the code", "fix a bug"), you **MUST** read the corresponding file in `.gemini/workflows/` using the `read_file` tool before taking any other action.

Refer to `.gemini/workflows/` for detailed SOPs (Standard Operating Procedures) for common tasks:
- `make-plan.md`: Requirement analysis and plan creation (Consider using `enter_plan_mode` for complex tasks).
- `review-plan.md`: Review and improve existing plans.
- `execute-plan.md`: Implementing approved plans using TDD (Red-Green-Refactor).
- `fix-bug.md`: Structured bug diagnosis and resolution.
- `review-code.md`: Comprehensive code change review.
- `simplify-code.md`: Simplify code without behavior changes.
- `explore.md`: Codebase exploration and findings summary.
- `create-issue.md`: Create standalone GitHub issues.
- `create-pr.md`: Create pull requests with summaries.
- `recap.md`: Session insights and memory capture.

---

## Agent Mapping (Claude -> Gemini)

If instructions refer to Claude-specific agents, use these Gemini equivalents:

| Claude Agent | Gemini CLI Tool / Workflow |
|--------------|---------------------------|
| **code-explorer** | `codebase_investigator` tool & `.gemini/workflows/explore.md` |
| **feature-planner** | `.gemini/workflows/make-plan.md` & `.gemini/workflows/review-plan.md` |
| **architecture-strategist** | `.gemini/workflows/make-plan.md` (with deep architectural focus) |
| **dedicated-coder** | `.gemini/workflows/execute-plan.md` (high precision) |
| **rapid-coder** | `.gemini/workflows/execute-plan.md` (fast execution) |
| **code-quality-auditor** | `.gemini/workflows/review-code.md` |
