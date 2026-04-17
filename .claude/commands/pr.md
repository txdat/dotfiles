# /pr — Create Pull Request

## Purpose
Checkout to a properly named branch and create a well-structured PR with clear WHAT and HOW sections.

---

## Step 1: Gate Check

Resolve plans directory: read `plansDirectory` from project `CLAUDE.md`. If not set, default to `plans/`. Use this as `<plansDir>` throughout.

Resolve the active plan file: find the `.md` in `<plansDir>` with status `implemented` or `reviewed`. If multiple match, ask the user which one. If none found, warn the user and ask for explicit confirmation to proceed.
Read the resolved plan file and project `CLAUDE.md` for the PR checklist.

---

## Step 2: Branch

Check current branch:
```bash
git branch --show-current
git status
```

If on `main` or `master`, checkout a new branch:
```bash
git checkout -b <type>/<slug>
```

Branch naming rules:
- Format: `<type>/<kebab-case-description>`
- Types: `feat`, `fix`, `refactor`, `chore`, `migration`, `hotfix`
- Slug: derived from task name in the resolved plan file, max 5 words
- Example: `feat/idempotency-key-payment-api`

If already on a feature branch, stay on it.

---

## Step 3: Final Checks

```bash
# Uncommitted changes?
git status

# Untracked files that should be committed?
git status --short

# Debug artifacts?
git diff main | grep -nE "System\.out|\.debug\(|console\.log|print\(|// DEBUG"

# Conflict markers?
git diff main | grep -nE "^[<>]{7}|^={7}"
```

If any issues found → stop and fix before continuing.

Stage and commit if there are uncommitted changes:
```bash
git add -A
git commit -m "<type>(<scope>): <imperative summary>"
```

Commit message format: `feat(payment): add idempotency key validation`

---

## Step 4: Generate PR Description

Read the resolved plan file and `git diff main` to produce:

---

### Title
`<type>(<scope>): <imperative summary under 72 chars>`

---

### WHAT
*What changed? What is this PR introducing or fixing?*

Write 3–6 bullet points. Each bullet = one meaningful change.
Focus on observable behavior, not file names.

Examples:
- ✅ "Added idempotency key validation on payment submission endpoint"  
- ❌ "Modified PaymentService.java"

---

### HOW
*How was it implemented? What approach was chosen and why?*

Write 2–4 paragraphs covering:
1. The core implementation approach and why it was chosen over alternatives
2. Any non-obvious technical decisions (reference the Design Decisions table from the plan)
3. How correctness is ensured (transactions, locking, validation strategy)
4. What was deliberately left out of scope

This section is for the reviewer — give them enough context to evaluate the approach, not just read the code.

---

### Testing
- What tests were added or modified
- What invariants are verified
- Any manual testing steps needed

---

### Checklist
Copy the checklist from project `CLAUDE.md` and fill it in.
If no project checklist exists, use:
- [ ] Tests pass
- [ ] No debug artifacts
- [ ] No secrets committed  
- [ ] Migrations are backward-compatible (if applicable)
- [ ] Breaking changes documented (if applicable)

---

## Step 5: Create the PR

```bash
gh pr create \
  --title "<title>" \
  --body "<full body>" \
  --draft
```

Default: always `--draft` unless user passes `/pr ready` as argument.

After creation:
- Print the PR URL
- Update the resolved plan file status to `pr-created` and record the URL
- Print: "Draft PR created. Run /recap before closing the session."
