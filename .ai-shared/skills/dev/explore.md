# /explore — Codebase Exploration

If `~/.dotfiles/.ai-shared/CODING.md` is not yet loaded, read it first.

Target from $ARGUMENTS or ask. Read AI project configuration. Read-only: modify nothing.

## Area Decomposition

Identify distinct areas (e.g. auth, API, DB). Single area → explore inline.

Otherwise, write to `/tmp/ai-ctx/<slug>.md`:
```
Target: <feature/module/question>
Stack: <detected>
Standards: <from project config>
Constraints: Read-only. Report findings only.
```

Spawn parallel `code-explorer` per area:
```
Read `/tmp/ai-ctx/<slug>.md` first.
Explore: <area>. Report: entry points, key files, data flow, patterns, gotchas.
```

## Output

```
## Exploration: <target>

### Entry Points
- `file:line` — <description>

### Key Files
- `file` — <what it owns>

### Data Flow
<input → transform → output>

### Patterns
- <pattern>: <where>

### Shared Mutable State
- `<identifier>` — writers: <flow (semantic), ...>; readers: <flow (usage), ...>

### Gotchas
- <constraint or issue>

### Open Questions
- <unclear before planning>
```

## Self-Check (BLOCKING)

- [ ] **Read-only:** no file modified.
- [ ] **Evidence:** every Entry Point, Key File, and Pattern carries a real `file:line` from tool output; data flow traced input → transform → output.
- [ ] **Honest blanks:** Gotchas and Open Questions are filled or explicitly `none` — never omitted.

All checked → emit: "Exploration complete."
