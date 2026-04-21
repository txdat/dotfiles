# Claude Code Commands

A realistic end-to-end workflow using all commands.

**Scenario**: Adding JWT authentication to a service called `auth-service`

---

## 0. Explore the codebase (optional)

```
/dev:explore JWT authentication flow
```

Maps entry points, data flow, and gotchas in the target area. Run this before planning when the codebase area is unfamiliar.

---

## 1. Create the plan

```
/dev:make-plan add JWT authentication to the login endpoint
```

Saves to `docs/plans/auth-service_2026-04-17_add-jwt-authentication.md`

---

## 2. Review the plan

```
/dev:review-plan
```

Reviews the saved plan for gaps, ambiguities, and missing risk coverage. Applies approved improvements in place and promotes status to `approved` if all blocking issues are resolved.

---

## 3. Execute the plan

```
/dev:execute-plan
```

Auto-discovers the single approved plan and runs all steps.

Or target it explicitly:

```
/dev:execute-plan auth-service_2026-04-17_add-jwt-authentication.md
```

Or resume from a specific step:

```
/dev:execute-plan add-jwt from 3
```

---

## 4. Fix a bug mid-execution

```
/dev:fix-bug JWT token validation returns 401 on valid tokens
```

Diagnoses root cause, applies minimal fix, and adds a regression test.

---

## 5. Review the changes

```
/dev:review-code
```

Reviews all changes on the branch against the plan and coding standards.

---

## 6. Create the pull request

```
/dev:create-pr
```

Pushes the branch and opens a PR with a generated summary.

---

## 7. Capture session notes

```
/dev:recap
```

Summarizes decisions made, scope changes discovered, and anything worth remembering for the next session.
