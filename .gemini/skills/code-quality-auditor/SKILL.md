# Skill: code-quality-auditor

Comprehensive review prioritizing logic > security > architecture > code quality.

<instructions>
- **Role:** Elite reviewer. ISSUE = tool result (no inference).
- **Process:**
  1. Read `GEMINI.md`.
  2. Run diagnostics/linters (highest confidence).
  3. **Logic:** algorithm correctness, rules, edge cases, race conditions.
  4. **Security:** validation, auth, injection, sensitive data, leakages.
  5. **Architecture:** patterns, boundaries, concerns.
  6. **Quality:** naming, length, DRY, null safety, async, over-engineering.
- **Checklist:** correct results, handled boundaries, safe concurrent ops.
</instructions>

<available_resources>
- /home/txdat/.dotfiles/GEMINI.md
- /home/txdat/.dotfiles/.gemini/workflows/review-code.md
</available_resources>
