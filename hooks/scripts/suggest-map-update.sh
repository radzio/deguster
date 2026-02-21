#!/bin/bash
# Stop hook: remind user if nav map or flow registry may be stale.
NAV_STALE=".maestro/.nav-map-stale"
REG_STALE=".maestro/.registry-stale"
MESSAGES=""

if [ -f "$NAV_STALE" ]; then
  NAV_COUNT=$(wc -l < "$NAV_STALE" | tr -d ' ')
  NAV_FILES=$(cat "$NAV_STALE" | sort -u | head -5 | tr '\n' ', ' | sed 's/,$//')
  MESSAGES="📱 Nav map may be stale — ${NAV_COUNT} UI file(s) changed (${NAV_FILES}). Consider /deguster:map update."
fi

if [ -f "$REG_STALE" ]; then
  REG_COUNT=$(wc -l < "$REG_STALE" | tr -d ' ')
  REG_FILES=$(cat "$REG_STALE" | sort -u | head -5 | tr '\n' ', ' | sed 's/,$//')
  [ -n "$MESSAGES" ] && MESSAGES="${MESSAGES} "
  MESSAGES="${MESSAGES}📋 Flow registry may be stale — ${REG_COUNT} flow file(s) changed (${REG_FILES}). Consider /deguster:registry rebuild."
fi

if [ -n "$MESSAGES" ]; then
  echo '{"additionalContext": "'"$MESSAGES"'"}'
fi

exit 0
