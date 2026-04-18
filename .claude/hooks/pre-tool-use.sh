#!/bin/bash
# Pre-Tool-Use Hook — Security gate
# Blocks dangerous commands, logs tool usage

INPUT=$(cat 2>/dev/null)

# Extract tool info
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null)

# SECURITY: Block hook modification
if [[ "$FILE_PATH" =~ \.claude/hooks/ ]] && [[ "$TOOL_NAME" =~ ^(Edit|Write)$ ]]; then
  echo "[BLOCKED: Cannot modify hook scripts directly. Use /reset-settings.]" >&2
  exit 2
fi

# SECURITY: Block dangerous commands
if [[ -n "$COMMAND" ]]; then
  if echo "$COMMAND" | grep -qiE "rm\s+-rf\s+/|chmod\s+.*777|eval\s*\(|mkfs|dd\s+if="; then
    echo "[BLOCKED: Dangerous command detected.]" >&2
    exit 2
  fi
fi

# Pass through — allow the operation
exit 0
