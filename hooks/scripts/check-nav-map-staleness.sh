#!/bin/bash
# PostToolUse hook: detect when UI-related files change and flag nav map as stale.
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -1 | cut -d'"' -f4)

[ -z "$FILE_PATH" ] && exit 0
[ ! -f ".maestro/nav-map.md" ] && exit 0

UI_PATTERNS="(Screen|View|Activity|Fragment|Controller|Page|Component|Navigator|Router|TabBar|BottomNav|navigation|routes)"

if echo "$FILE_PATH" | grep -qiE "$UI_PATTERNS"; then
  mkdir -p .maestro
  echo "$FILE_PATH" >> .maestro/.nav-map-stale
  echo '{"additionalContext": "⚠️ UI file changed: '"$FILE_PATH"'. Nav map may need updating."}'
fi

exit 0
