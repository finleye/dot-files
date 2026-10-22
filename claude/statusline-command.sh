#!/bin/sh
# Claude Code status line - styled after Powerlevel10k Pure theme
# Segments: dir  git-branch  model  context%  cost  time

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Shorten home directory to ~
home="$HOME"
short_cwd="${cwd/#$home/~}"

# Git branch (skip optional lock file to avoid contention)
git_branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree --no-optional-locks >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

time_str="$(date +%H:%M:%S)"

# Build output with ANSI colors matching Pure/p10k palette
# grey=242, magenta=5, cyan=6, yellow=3
printf '\033[34m%s\033[0m' "$short_cwd"

if [ -n "$git_branch" ]; then
  printf '  \033[38;5;242m%s\033[0m' "$git_branch"
fi

printf '  \033[35m%s\033[0m' "$model"

if [ -n "$used_pct" ]; then
  printf '  \033[38;5;242mctx: \033[33m%s%%\033[0m' "$(printf '%.0f' "$used_pct")"
fi

if [ -n "$cost" ]; then
  printf '  \033[38;5;242m$\033[32m%s\033[0m' "$(printf '%.4f' "$cost")"
fi

printf '  \033[38;5;242m%s\033[0m' "$time_str"
printf '\n'
