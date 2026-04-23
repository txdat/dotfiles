# Workflow: /create-pr — Pull Request Generation

Find active plan (implemented/reviewed). Read `GEMINI.md`.

1. **Branch:** If protected, create `<type>/<slug>`.
2. **Checks:** grep for debug artifacts/conflict markers.
3. **Commit:** `<type>(<scope>): <summary>`.
4. **Generate:**
   - **WHAT:** behavior changes bullets.
   - **HOW:** approach & key decisions.
   - **Testing:** tests added & invariants verified.
   - **Closes:** link issue if present.

Run `gh pr create --draft`. Update plan status `pr-created`.
