# /explore — Codebase Exploration

Resolve `~/.dotfiles/.ai-shared/CODING.md`'s code navigation cascade before any file read, grep, or agent spawn. (Load CODING.md first if not yet read this session.)

## Step 1 — Target

From $ARGUMENTS or ask. Read AI project config. Read-only: modify nothing.

## Step 2 — Area Decomposition

Identify distinct areas (e.g. auth, API, DB). Single area → explore inline.

Otherwise, write to `/tmp/ai-ctx/<slug>.md`:
```
Target: <feature/module/question>
Stack: <detected>
Standards: <from project config>
Constraints: Read-only. Report findings only.
Tooling: Read ~/.dotfiles/.ai-shared/CODING.md; use the highest available tier from its code navigation cascade.
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

- [ ] **Tooling gate:** highest available navigation tier was identified and used for all exploration.
- [ ] **Read-only:** no file modified.
- [ ] **Evidence:** every Entry Point, Key File, and Pattern carries a real `file:line` from tool output; data flow traced input → transform → output.
- [ ] **Honest blanks:** Gotchas and Open Questions are filled or explicitly `none` — never omitted.

All checked → emit: "Exploration complete."
