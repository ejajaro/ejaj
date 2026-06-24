# ejajaro / ejaj

Monorepo for the `@ejaj` toolchain: `@ejaj/grove` (git-worktree lifecycle CLI, first tool),
with `@ejaj/core`, `@ejaj/cli`, and `@ejaj/maestro` stubbed for later. pnpm + TypeScript workspace.

## Agent skills

This repo uses [mattpocock/skills](https://github.com/mattpocock/skills) (installed under
`.claude/skills/`). The engineering skills read the repo-specific config below.

### Where AI-generated docs go — DEFAULT to `ai-docs/`

Generated docs are **hidden by default, visible only on request**:

- **Hidden (default)** → `ai-docs/` (local, gitignored). Any doc you generate — PRDs, plans, specs,
  analyses, design drafts, reports, scratch notes — lands here unless told otherwise. Mirror the
  package path under it (e.g. `ai-docs/grove/prd.md`).
- **Visible (only when the user explicitly asks)** → the tracked `docs/` tree (e.g.
  `docs/<pkg>/prd.md`). Triggers: the user says to make it "visible", "commit it", "put it in
  `docs/`", "publish the doc", or names a tracked path. Absent an explicit ask, never write a
  generated doc into `docs/`.

When you move a doc from hidden to visible, `git mv` (or copy) it from `ai-docs/<…>` to the matching
`docs/<…>` path and tell the user it's now tracked. The shared agent config under `ai-docs/agents/` is
the only committed part of `ai-docs/`. Committed `docs/` otherwise holds only skill-managed `docs/adr/`
ADRs and per-package `CONTEXT.md`.

### Issue tracker

GitHub Issues in `ejajaro/ejaj`, via the `gh` CLI. See `ai-docs/agents/issue-tracker.md`.

### Triage labels

Canonical 5-state vocabulary (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`,
`wontfix`) — workflow states, separate from the issue-type labels (`bug`/`feature`/`task`/`epic`/`chore`).
See `ai-docs/agents/triage-labels.md`.

### Domain docs

Multi-context monorepo: per-package `CONTEXT.md` (under `packages/*`/`apps/*`), mapped by a root
`CONTEXT-MAP.md`; ADRs under `docs/adr/`. All created lazily by the skills. See `ai-docs/agents/domain.md`.
