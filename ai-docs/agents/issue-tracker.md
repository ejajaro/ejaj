# Issue tracker: GitHub

Issues and PRDs for this repo live as GitHub issues in **`ejajaro/ejaj`**. Use the `gh` CLI for all
operations (`gh` infers the repo from `git remote -v` when run inside the clone).

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments` (also fetch labels).
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` / `--state` filters.
- **Comment**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

## Issue types vs triage labels

This repo has two distinct label families:

- **Issue types** (what kind of work): `bug`, `feature`, `task`, `epic`, `chore` — set on creation,
  matching the `.github/ISSUE_TEMPLATE/` forms.
- **Triage state** (where it is in the workflow): see `triage-labels.md`.

## When a skill says "publish to the issue tracker"

Create a GitHub issue in `ejajaro/ejaj`.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.
