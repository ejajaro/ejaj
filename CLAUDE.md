# ejajaro / ejaj

Monorepo for the `@ejaj` toolchain: `@ejaj/grove` (git-worktree lifecycle CLI, first tool),
with `@ejaj/core`, `@ejaj/cli`, and `@ejaj/maestro` stubbed for later. pnpm + TypeScript workspace.

## Agent skills

This repo uses [mattpocock/skills](https://github.com/mattpocock/skills) (installed under
`.claude/skills/`). The engineering skills read the repo-specific config below. AI-generated working
docs go to `ai-docs/` (local, gitignored); the shared config under `ai-docs/agents/` is committed.

### Issue tracker

GitHub Issues in `ejajaro/ejaj`, via the `gh` CLI. See `ai-docs/agents/issue-tracker.md`.

### Triage labels

Canonical 5-state vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`,
`wontfix`) — workflow states, separate from the issue-type labels (`bug`/`feature`/`task`/`epic`/`chore`).
See `ai-docs/agents/triage-labels.md`.

### Domain docs

Multi-context monorepo: per-package `CONTEXT.md` (under `packages/*`/`apps/*`), mapped by a root
`CONTEXT-MAP.md`; ADRs under `docs/adr/`. All created lazily by the skills. See `ai-docs/agents/domain.md`.
