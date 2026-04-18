#!/bin/bash
# Subagent Stop Hook — Track agent completion
# Logs agent usage for the archivist and session tracking

INPUT=$(cat 2>/dev/null)
PROJECT_ROOT="${PROJECT_ROOT:-.}"
LOG_DIR="$PROJECT_ROOT/.claude/logs"
AGENT_LOG="$LOG_DIR/.agent-usage.jsonl"

# Extract agent info
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // ""' 2>/dev/null)

if [[ -z "$AGENT_ID" || "$AGENT_ID" == "null" ]]; then
  exit 0
fi

# Log agent completion
mkdir -p "$LOG_DIR" 2>/dev/null
TIMESTAMP=$(date -Iseconds)
echo "{\"ts\":\"$TIMESTAMP\",\"event\":\"agent_stop\",\"agent_id\":\"$AGENT_ID\"}" >> "$AGENT_LOG" 2>/dev/null

# Increment agent counter
COUNTER_FILE="$LOG_DIR/.agent-counter"
COUNTER=$(cat "$COUNTER_FILE" 2>/dev/null || echo "0")
NEXT=$((COUNTER + 1))
echo "$NEXT" > "$COUNTER_FILE" 2>/dev/null

exit 0
