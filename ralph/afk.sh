#!/usr/bin/env bash
#
# Ralph AFK loop for ejajaro/ejaj.
#
# Runs Claude Code headless, one `ready-for-agent` GitHub issue per iteration, until the queue is
# empty or the iteration budget is spent. Each iteration is a FRESH Claude process — state lives in
# git commits and issue labels, never in a carried conversation (the "Ralph" pattern).
#
# Usage:
#   bash ralph/afk.sh [iterations]     # default 10
#
# Requires: `claude`, `gh` (authenticated), `jq`. Run on a feature branch, never main.
# acceptEdits auto-approves file edits; the shell commands the loop needs are allowlisted in
# .claude/settings.json so it can run unattended.

set -eo pipefail

ITERATIONS="${1:-10}"
LABEL="ready-for-agent"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- safety: never run on main -------------------------------------------------
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "main" ]; then
  echo "Refusing to run Ralph on 'main'. Switch to a feature branch first." >&2
  exit 1
fi

# jq filters over the stream-json output ----------------------------------------
# render assistant text live to the terminal
stream_text='select(.type == "assistant").message.content[]? | select(.type == "text").text // empty | gsub("\n"; "\r\n") | . + "\r\n\n"'
# the final result string (where the NO MORE TASKS sentinel shows up)
final_result='select(.type == "result").result // empty'

echo "Ralph starting on branch '$branch' — up to $ITERATIONS iteration(s)."

for ((i = 1; i <= ITERATIONS; i++)); do
  echo ""
  echo "──────────── Ralph iteration $i / $ITERATIONS ────────────"

  # exit early if there is nothing labelled ready-for-agent
  open_count="$(gh issue list --label "$LABEL" --state open --json number --jq 'length')"
  if [ "$open_count" -eq 0 ]; then
    echo "No open '$LABEL' issues. Ralph complete after $((i - 1)) iteration(s)."
    exit 0
  fi
  echo "$open_count open '$LABEL' issue(s) in the queue."

  # assemble fresh context: the issue queue + recent commits + the standing prompt
  issues="$(gh issue list --label "$LABEL" --state open \
    --json number,title,body,labels,comments \
    --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]')"
  commits="$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")"
  prompt="$(cat "$SCRIPT_DIR/prompt.md")"

  tmpfile="$(mktemp)"
  trap 'rm -f "$tmpfile"' EXIT

  claude --permission-mode acceptEdits \
    --print \
    --verbose \
    --output-format stream-json \
    "Open ${LABEL} issues (JSON): ${issues}

Recent commits:
${commits}

${prompt}" \
    | grep --line-buffered '^{' \
    | tee "$tmpfile" \
    | jq --unbuffered -rj "$stream_text"

  result="$(jq -r "$final_result" "$tmpfile")"
  rm -f "$tmpfile"

  if [[ "$result" == *"<promise>NO MORE TASKS</promise>"* ]]; then
    echo ""
    echo "Ralph reports NO MORE TASKS after $i iteration(s)."
    exit 0
  fi
done

echo ""
echo "Reached the iteration budget ($ITERATIONS). Re-run to continue, or inspect the work so far."
