---
name: dev-review-infra
description: "Review an infra/devops runbook against live state with read-only commands: phase ordering, rollback safety, DNS/traffic cutover sequencing, IaC completeness, and CI/CD coverage, before a human runs it. Add 'post' to instead audit what actually ran afterward — success criteria, divergence, unmet destruction gates, leftover resources, remaining phases. Never executes, resumes, or remediates a runbook."
model: sonnet
effort: high
---

Read `~/.dotfiles/.ai-shared/skills/dev/review-infra.md` and follow all instructions exactly.
