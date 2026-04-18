#!/bin/bash
# Session Start Hook — Terminal title + session logging
# Sets terminal title with emoji + project name + date

PROJECT_ROOT="${PROJECT_ROOT:-.}"
PROJECT_NAME=$(basename "$(cd "$PROJECT_ROOT" && pwd)")
DATE=$(date +%Y-%m-%d_%H%M)
LOG_DIR="$PROJECT_ROOT/.claude/logs/sessions"

# Set terminal title
echo -ne "\033]0;🚀 ${PROJECT_NAME} | Claude Code | ${DATE}\007"

# Create log directory if needed
mkdir -p "$LOG_DIR" 2>/dev/null

# Start session log
SESSION_LOG="$LOG_DIR/${DATE}_session.md"
if [ ! -f "$SESSION_LOG" ]; then
  cat > "$SESSION_LOG" << EOF
# Session: ${DATE} — ${PROJECT_NAME}

## Started
$(date -Iseconds)

## Agents Used
| # | Agent | Task | Status |
|---|-------|------|--------|

## Commits

## Notes

EOF
fi

exit 0
