#!/bin/bash
# PreToolUse hook: auto-approve safe read-only maestro and mobilecli commands.
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -o '"command":"[^"]*"' | head -1 | cut -d'"' -f4)

if echo "$COMMAND" | grep -qE "^maestro (hierarchy|test|studio)"; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Safe maestro command"}}'
  exit 0
fi

if echo "$COMMAND" | grep -qE "^mobilecli (devices|apps list|apps foreground|screenshot)"; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Safe mobilecli command"}}'
  exit 0
fi

exit 0
