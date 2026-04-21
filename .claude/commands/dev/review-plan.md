---
effort: high
---

# /review-plan — Review and Improve an Existing Plan

Do NOT write any code.

Plans directory: `docs/plans/`. Find plan from $ARGUMENTS (full/partial name) or auto-discover by status `planning`/`approved`. If multiple, ask. If none, stop. If the plan references unfamiliar codebase areas, suggest running `/dev:explore` on them first.

Read the plan plus project `CLAUDE.md` and `~/.claude/CLAUDE.md`.

---

Review:
- **Requirement**: clear problem statement, measurable definition of done
- **Scope**: in/out explicitly defined, no hidden assumptions
- **Design decisions**: alternatives considered, reasoning stated
- **Risks**: each has an actionable mitigation
- **Steps**: dependency-ordered; target 5–10; each verifiable. If steps exceed 10, flag `❌` blocking — propose a split.

Flag ambiguities: undefined terms, missing constraints, unaddressed edge cases, unstated assumptions. If unresolvable from the plan, ask — one follow-up round maximum.

**TDD compliance (blocking)**: non-empty `### Test Steps`; all Test Steps before Implementation Steps; every Implementation Step references a Test Step. Missing TDD structure is always `❌` — propose the missing test steps. Validate Test Step content by plan type:
- *Feature/fix*: each Test Step must describe a new failing test
- *Refactor*: each Test Step must describe coverage verification or characterization tests that pass before and after

---

Produce:

```
## Plan Review: <filename>

### ✅ What's solid
### ❌ Issues (must fix before execution)
- Section — <issue> — <suggested fix>
### ⚠️ Suggestions (recommended, not blocking)
### Verdict: READY | NEEDS CHANGES
```

Ask: "Apply these changes?" Apply approved edits in place.

If status was `planning` and all blocking issues resolved → set `approved`.
Print: "Plan updated. Run /dev:execute-plan to begin."
