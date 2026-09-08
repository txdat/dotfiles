# /recap — Learn from a Plan-Based Session

Draft utility for extracting reusable lessons from a development session. Use when the user asks for a retrospective, lessons learned, or improvements to a plan-based workflow. `handoff` owns continuity; the phase review skills own readiness and correctness verdicts.

## Input and Scope

Read AI project configuration and `~/.dotfiles/.ai-shared/PROCESS.md`. Take an exact `docs/plans/<file>.md` from the user's request or an exact archived-plan comment URL. For an archived comment, establish the original plan basename and repository from its contents. If the artifact is unnamed or ambiguous, ask for its path or comment URL; do not choose the newest plan.

Recap is retrospective and accepts any recorded status, including `archived` or `abandoned`. It does not enter an execution phase, change status, reopen a plan, or certify completion. It is optional and adds no gate to the delivery cycle.

Output the recap in the conversation by default. Save it when the user requests a file, following their destination or the project's existing recap convention. Recapping alone does not authorize edits to skills, project rules, plans, issues, or PRs. Carry out separately requested changes within the user's existing authorization.

## Gather Evidence

1. Resolve plan identity from the exact artifact. Before a worktree is created, the local plan is authoritative. Once `Worktree:` is recorded, use the worktree copy; the main-tree file is only a locator and may contain an outdated spec and status. If the worktree or its plan is missing, use a matching verified archive comment, or produce a partial recap explicitly identifying the locator as incomplete historical evidence. Never infer completion or abandonment from the missing directory. An abandoned locator records the terminal decision but may lack execution history. Match archived evidence to the repository, plan basename, issue, and reviewed SHAs in create-pr's archive marker. Read it from the surviving repository context; do not recreate a worktree to recap it.
2. Compare the Goal, ACs, TC intents, and planned steps with available review history, deviations, discovered scope, coverage gaps, commits, test output, and PR records. Inspect only artifacts relevant to this session. Read source code only when needed to support a lesson.
3. Use available session context for user corrections, rejected approaches, and reasons behind decisions. If context was compacted or is unavailable, state the limitation; do not invent the discussion or search unrelated session histories.
4. Separate observed facts, recorded reports, and inferred explanations. A commit label does not prove a test run; a missing record does not prove a step was skipped. `archived` establishes PR publication under this workflow, not merge or deployment. New checks establish current behavior, not historical results.

Unavailable evidence limits the affected claim, not the whole recap. Produce a partial recap with the missing sources named once the plan's identity is established.

## Extract Lessons

Focus on decisions that changed the outcome: a missed assumption, useful counterexample, failed approach, effective verification, repeated friction, or user correction. Compare what was knowable at the time with what emerged later. Include successful practices worth repeating; do not manufacture lessons to fill sections.

For each material lesson, record:

- **Observation and evidence:** what happened, with a plan section, commit SHA, test record, comment URL, or identifiable session statement.
- **Explanation:** why it mattered; label an unproven cause as a hypothesis.
- **Next-time action and boundary:** the concrete trigger and action, plus where the lesson applies. One session's scope choice is not a permanent user preference or universal rule.

Separate unfinished product work from improvements to the development process. An unresolved integration check is remaining work; checking runner prerequisites earlier may be a process lesson. Neither is completed by writing a recap.

## Improvement Proposals

For lessons worth retaining, inspect the relevant existing guidance before proposing a change. Name its owning file and section, the smallest proposed wording or action, and how a future session could check whether it helped. If the rule already exists, distinguish an execution lapse from unclear or missing guidance; avoid adding a duplicate rule.

Keep project-specific facts in project documentation, transferable phase guidance in the owning dev skill, and role-specific boundaries/reporting in the owning `.ai-shared/agents/` file. Use shared rules only when evidence supports a cross-cutting change. A tentative explanation can remain a candidate lesson without becoming policy.

Proposals remain proposals until applied under the user's request. Preserve archived snapshots as historical evidence; propose a linked correction or follow-up if a record is incomplete. Do not rewrite history to make the session look compliant.

## Output

Keep the result proportional to the useful evidence:

```text
## Recap: <task>
Plan: <exact path or archived comment URL and original basename>
Scope: <session or phases covered>; recorded status: <status>
Evidence limits: <missing context or unverified results, or none>

### Plan versus outcome
<Material differences, decisions, and observed results, with sources.>

### Lessons
<Observation + evidence → explanation → next-time action and boundary.>

### Proposed improvements
<Owning file/section → concrete proposal → future validation; or none.>

### Remaining work
<Unresolved product work and verification, with existing references; or none.>
```

## Self-Check (BLOCKING)

- [ ] The recap identifies one exact plan and the session or phases it covers.
- [ ] Material claims cite available evidence; reports, hypotheses, and missing proof are distinguished.
- [ ] Lessons name actionable changes and their applicability; proposals account for existing guidance.
- [ ] Remaining work and publication/merge/deployment states are reported accurately.
- [ ] Only requested artifacts were written; proposed improvements are not presented as adopted rules.

All checked → deliver the recap and any requested output path. This signals recap completion only.
