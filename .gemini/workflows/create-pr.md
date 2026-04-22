# Workflow: /create-pr — Create Pull Request

Find active plan (status `implemented`/`reviewed`).

1. **Pre-flight Checks**:
   - Check for debug artifacts (e.g., `console.log`, `// DEBUG`).
   - Check for conflict markers.
2. **Stage and Commit**: `<type>(<scope>): <imperative summary>`.
3. **Generate Description**:
   - **WHAT**: 3–6 bullets of observable behavior changes.
   - **HOW**: implementation approach and design decisions.
   - **Testing**: tests added and invariants verified.
   - **Closes**: if plan has `Issue:` set (e.g. `Issue: 42`), append `Closes #42` to PR body.
4. **Execute**:
   ```bash
   gh pr create --title "..." --body "..." --draft
   ```
5. **Report**: Print PR URL and update plan status to `pr-created`.
