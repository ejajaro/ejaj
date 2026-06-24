#!/usr/bin/env bash
#
# Ralph — one supervised pass.
#
# Same context as afk.sh (the ready-for-agent queue + recent commits + the standing prompt), but
# runs Claude INTERACTIVELY so you can watch it work and approve anything not yet allowlisted.
# Use this to build trust before going AFK with afk.sh.
#
# Usage:
#   bash ralph/once.sh
#
# Requires: `claude`, `gh` (authenticated), `jq`.

set -eo pipefail

LABEL="ready-for-agent"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "main" ]; then
  echo "Refusing to run Ralph on 'main'. Switch to a feature branch first." >&2
  exit 1
fi

open_count="$(gh issue list --label "$LABEL" --state open --json number --jq 'length')"
if [ "$open_count" -eq 0 ]; then
  echo "No open '$LABEL' issues. Nothing to do."
  exit 0
fi

issues="$(gh issue list --label "$LABEL" --state open \
  --json number,title,body,labels,comments \
  --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]')"
commits="$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")"
prompt="$(cat "$SCRIPT_DIR/prompt.md")"

claude --permission-mode acceptEdits \
  "Open ${LABEL} issues (JSON): ${issues}

Recent commits:
${commits}

${prompt}"
