# Workflow: /make-infra-plan — Infrastructure Approval

Plans dir: `docs/plans/`. read `GEMINI.md`.

## Phase 1 — Draft
1. **Audit:** READ-ONLY commands (terraform show, kubectl get).
2. **Drift Detection:** Compare live state vs manifests.
3. **Steps:** Pre-flight (audit), Impl (ordered changes), Verification (post-apply), Rollback (undo).
4. **Gate:** every destructive step needs dry-run command. Rollback must have trigger.

## Phase 2 — Review & Approve
1. **Review:** explicit env targets, failure modes, rollback path.
2. **Sync:** Enforce sync step if drift detected.
3. **Status:** Set `Status: approved`.
