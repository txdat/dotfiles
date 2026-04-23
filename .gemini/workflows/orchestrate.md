# Workflow: /orchestrate — Full Development Cycle

Flow: **explore → plan → execute → review → recap → pr**

Target: `<requirement or issue #>`. Read `GEMINI.md`.

## State Detection
If resume point not provided, auto-detect via plan status in `docs/plans/`:
- none → `explore`
- `planning` → `plan`
- `approved`/`in-progress` → `execute`
- `implemented` → `review`
- `reviewed` → `recap`
- `pr-created` → cycle complete.

## Phases
1. **explore:** Follow `/explore` logic. Output findings. **PAUSE** for confirmation.
2. **plan:** If `planning` exists, follow `/review-plan`. Otherwise, follow `/make-plan`. Outputs `approved`. **PAUSE** for confirmation.
3. **execute:** Follow `/execute-plan`. RED→GREEN→BLUE. **PAUSE** for confirmation.
4. **review:** Follow `/review-code`. If rework required, fix inline. **PAUSE** for confirmation.
5. **recap:** Follow `/recap`. **PAUSE** for confirmation.
6. **pr:** Follow `/create-pr`. Default `--draft`.
