#!/bin/bash
# Stop hook: remind user if nav map may be stale after UI file changes.
STALE_FILE=".maestro/.nav-map-stale"

if [ -f "$STALE_FILE" ]; then
  CHANGED_COUNT=$(wc -l < "$STALE_FILE" | tr -d ' ')
  CHANGED_FILES=$(cat "$STALE_FILE" | sort -u | head -5 | tr '\n' ', ' | sed 's/,$//')
  echo '{"additionalContext": "📱 Nav map may be stale — '"$CHANGED_COUNT"' UI file(s) changed ('"$CHANGED_FILES"'). Consider /deguster:map update."}'
fi

exit 0
