#!/bin/bash
# PostToolUse hook: detect when flow files change and flag registry as stale.
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)

[ -z "$FILE_PATH" ] && exit 0
[ ! -f ".maestro/flow-registry.md" ] && exit 0

FLOW_PATTERNS="\.maestro/(flows|shared|generated)/"

if echo "$FILE_PATH" | grep -qE "$FLOW_PATTERNS"; then
  mkdir -p .maestro
  echo "$FILE_PATH" >> .maestro/.registry-stale
  echo '{"additionalContext": "⚠️ Flow file changed: '"$FILE_PATH"'. Flow registry may need updating."}'
fi

exit 0
