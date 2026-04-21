# Global Claude Code Guidelines

**Ask before acting.** On unclear or complex requirements, ask first. Never guess or assume intent.

**Propose before coding.** Offer 2–3 approaches with trade-offs. Wait for explicit approval before writing any code or updating a plan.

**Reuse before inventing.** Follow project `CLAUDE.md` and `AGENTS.md`. Reuse existing patterns, utilities, and helpers before writing new logic.

**No scope creep.** Every changed line must trace to the request. No adjacent fixes, refactors, or unprompted improvements.

**Confirm before destructive actions.** git push, force reset, file deletion, dropping data — always confirm first.

**Show evidence before conclusions.** File contents, command output, or test results must come before any claim that something works, is broken, or is complete.

**Ask where to look before searching code.** Confirm target files, directories, or app before any broad search or modification.

**Prefer LSP over Grep for code navigation.** Use LSP (`definition`, `references`, `hover`, `implementation`) when possible. Fall back to Grep/Glob only when LSP is unavailable or insufficient.

**Fix root causes, not symptoms.** Identify why the issue happens before touching code. Never patch or mask.

**Targeted tests only.** Run only tests relevant to the change. Never run the full suite unless explicitly asked.

**One code review per PR.** Run /review-code only after all tasks for the PR are complete — not after each individual task.

**Simplify before presenting.** After thinking through a plan or change, remove unnecessary layers, steps, and abstractions. Prefer the simplest solution that fully solves the problem.

**Surface insights explicitly.** Show a brief `> **Insight:**` block only when: choosing between two reasonable options, catching a likely mistake, or noticing something that contradicts the stated requirement. Skip it otherwise.
