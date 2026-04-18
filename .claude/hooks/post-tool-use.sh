#!/bin/bash
# Post-Tool-Use Hook — Log file edits
# Tracks all file modifications for audit trail

INPUT=$(cat 2>/dev/null)
PROJECT_ROOT="${PROJECT_ROOT:-.}"
LOG_FILE="$PROJECT_ROOT/.claude/logs/.edit-log.jsonl"

# Extract info
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null)

# Only log file modifications
if [[ "$TOOL_NAME" =~ ^(Edit|Write)$ ]] && [[ -n "$FILE_PATH" ]]; then
  mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
  TIMESTAMP=$(date -Iseconds)
  echo "{\"ts\":\"$TIMESTAMP\",\"tool\":\"$TOOL_NAME\",\"file\":\"$FILE_PATH\"}" >> "$LOG_FILE" 2>/dev/null
fi

exit 0
