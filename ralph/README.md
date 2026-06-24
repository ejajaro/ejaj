# Ralph — AFK agent loop

Ralph runs Claude Code unattended to implement GitHub issues labelled **`ready-for-agent`**, one per
iteration, until the queue is empty. It's the execution half of this repo's AFK pipeline:

```
to-prd → to-issues → triage  ⇒  issues labelled `ready-for-agent`  ⇒  ralph/afk.sh
```

It's the canonical [Ralph Wiggum](https://ghuntley.com/ralph/) pattern: re-run a *fresh* Claude on a
standing prompt, one task at a time. There is no carried conversation — **state lives in git commits
and issue labels**, and each iteration explores the repo from scratch.

## Prerequisites

- `claude` (Claude Code) — logged in with your Pro/Max **subscription** (the loop runs on the host, so
  no API key or container is needed).
- `gh` — authenticated, with access to `ejajaro/ejaj`.
- `jq`.
- The shell commands the loop uses are pre-allowlisted in `.claude/settings.json` so it runs without
  prompts under `acceptEdits`. (`acceptEdits` auto-approves file edits but **not** shell commands.)

## Usage

```bash
# 1. Be on a feature branch — never main.
git switch -c afk/ralph

# 2. Watch a single supervised pass first (interactive; you approve anything new):
bash ralph/once.sh

# 3. Go AFK — loop up to N iterations (default 10):
bash ralph/afk.sh 5
```

Start with ~3–5 iterations and inspect the commits before trusting it overnight.

## What each iteration does

1. Lists open `ready-for-agent` issues (with their **Agent Brief** comments) + the last 5 commits, and
   feeds them with `ralph/prompt.md` to a fresh `claude`.
2. Claude picks **one** issue by priority, implements it with `/tdd`, and runs `pnpm test`,
   `pnpm typecheck`, `pnpm lint`.
3. Commits on the current branch (conventional commit, references the issue).
4. Comments on the issue and swaps its label `ready-for-agent` → `ready-for-human`, leaving it **open**
   for your review. (If the task is unfinished, it keeps `ready-for-agent` and leaves a progress note.)
5. The loop stops when no `ready-for-agent` issues remain — Claude emits
   `<promise>NO MORE TASKS</promise>` and `afk.sh` exits.

## Files

| File         | Purpose                                                         |
| ------------ | -------------------------------------------------------------- |
| `prompt.md`  | The standing prompt — the contract every iteration runs against. |
| `afk.sh`     | The unattended loop (headless `claude --print`, bounded iterations). |
| `once.sh`    | One interactive supervised pass.                                |

## Safety

- **Never runs on `main`** — both scripts refuse and ask you to switch to a feature branch.
- **Human gate** — finished issues are relabelled `ready-for-human` and left open; nothing is closed or
  merged automatically. You review and give feedback.
- Review the branch's commits before pushing or opening a PR.
