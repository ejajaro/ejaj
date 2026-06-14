# `@ejaj/grove` — Requirements

> Status: **Draft** · Tracked by the grove Epic. This document is the source of truth for the
> first tool in the `ejaj` monorepo and seeds the Epic + sub-issues.

## 1. Problem

Working with multiple branches in parallel — for human review, for stacked changes, and
especially for AI agents that each need an isolated checkout — is painful with a single working
copy. `git stash`/branch-switching thrashes the working tree, rebuilds caches, and loses
in-progress dev state. Git **worktrees** solve the isolation problem but are tedious to operate
by hand: you must pick a path, create the branch, link the worktree, then re-prepare the dev
environment (install dependencies, copy env files, run setup hooks) every time — and clean it
all up afterwards.

`grove` is a CLI that manages the **full lifecycle** of a git worktree with a prepared,
ready-to-use development environment, so creating and disposing of isolated workspaces is a
single command.

## 2. Goals

- Create a worktree for a branch (new or existing) under a predictable location.
- Automatically **prepare the dev environment** in the new worktree (dependency install, env
  file propagation, optional setup hooks).
- Open / switch into an existing worktree (print its path or spawn a shell/editor).
- Close a worktree cleanly: remove the linked worktree, optionally delete the branch, prune.
- Be safe by default: never destroy uncommitted work without confirmation.

### Non-goals (initial)

- A long-running daemon or GUI (orchestration GUI is the separate `@ejaj/maestro` tool).
- Remote/CI worktree provisioning.
- Managing non-git VCS.

## 3. Command surface (sketch)

| Command | Purpose |
| --- | --- |
| `grove create <branch>` | Create a worktree for `<branch>` (creating the branch if needed), prepare its dev env, print the path. |
| `grove open [name]` | Print the path of (or open) an existing worktree; with no arg, list/select. |
| `grove close [name]` | Remove a worktree; prompt before discarding uncommitted changes; optionally delete the branch. |
| `grove list` | List managed worktrees with status (branch, path, dirty?). |

Global flags (indicative): `--root <dir>` (where worktrees live), `--base <ref>`,
`--no-install`, `--yes` (skip confirmations), `--json`.

## 4. Behavioral requirements

### 4.1 `create`
- Resolve a target path from a configurable root (default e.g. `../<repo>-worktrees/<name>`).
- If the branch does not exist, create it from `--base` (default: current `HEAD`'s upstream or
  the repo default branch).
- `git worktree add` the path + branch; fail clearly if the path or branch is already in use.
- Run the **prepare** sequence (§4.4) unless `--no-install`.
- Output the final path (and, with `--json`, a structured result).

### 4.2 `open`
- Resolve `name` to a managed worktree; error if ambiguous/missing.
- Default action prints the absolute path (so callers can `cd "$(grove open x)"`); optionally
  launch `$EDITOR`/`$SHELL` behind a flag.

### 4.3 `close`
- Refuse to remove a worktree with uncommitted/untracked changes unless `--yes`.
- `git worktree remove` then `git worktree prune`; optionally `git branch -d/-D`.

### 4.4 Prepare dev environment
- Detect package manager (pnpm/npm/yarn) and install dependencies.
- Propagate ignored-but-needed local files (e.g. `.env`, `.env.*`) from the primary worktree.
- Run optional user-defined setup hooks from config.

## 5. Configuration & validation

- Config is layered: built-in defaults → repo config file (e.g. `grove.config.*` or a key in
  `package.json`) → CLI flags.
- **All external inputs (CLI args, config files, env) are validated with `zod`** — the project
  standard. Invalid input fails fast with a readable message; see `WorktreeName` in
  `packages/grove/src/index.ts` for the canonical schema/type/parse pattern.

## 6. Acceptance criteria

- `grove create feat-x` produces a working, dependency-installed worktree and prints its path.
- Re-running `create` for an existing worktree is a clear no-op/error, not a corruption.
- `grove close feat-x` removes the worktree and prunes; it never silently discards dirty state.
- `grove list` reflects reality after create/close.
- Invalid names/flags produce zod-validated, actionable errors.
- Unit tests cover validation and lifecycle orchestration; the CLI has a smoke test.

## 7. Task / sub-issue breakdown (seed for the Epic)

1. **Config & validation layer** — zod schemas for config + CLI inputs, layered resolution.
2. **Git adapter** — thin wrapper over `git worktree add/remove/list/prune` + branch ops.
3. **`create` command** — path resolution, branch creation, worktree add, output.
4. **Prepare-environment step** — PM detection + install, env-file propagation, hooks.
5. **`open` / `list` commands** — resolution, listing, path/JSON output.
6. **`close` command** — safety checks, removal, prune, optional branch delete.
7. **CLI wiring & UX** — arg parser, help, `--json`, exit codes.
8. **Tests & CI** — unit + smoke tests wired into the workspace CI.
9. **Docs** — README + usage examples.
