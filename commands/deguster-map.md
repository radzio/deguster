---
description: Manage the app navigation map. Discover screens by crawling, view current map, or update specific sections.
argument-hint: "<discover <appId> | view [feature] | update <section> | add <feature> <path>>"
allowed-tools: Task, Bash, Read, Write, Glob
---

# App Menu Map: $ARGUMENTS

## Context
- Current nav map: !`cat .maestro/nav-map.md 2>/dev/null || echo "No nav map found. Run /deguster:map discover <appId> to create one."`
- Available devices: !`mobilecli devices 2>/dev/null`

## Instructions

Parse $ARGUMENTS to determine the action:

### `discover <appId>` — Auto-crawl and build map
Spawn an **app-crawler** subagent (Sonnet) to:
1. Launch the app via `mobilecli apps launch <appId> --device <id>`
2. Starting from the home/landing screen, systematically:
   - Run `maestro hierarchy` to capture current screen elements
   - Take screenshot via `mobilecli screenshot --device <id> --output .maestro/screenshots/map/<screen-name>.png`
   - Identify tappable elements that navigate to new screens
   - Tap each navigation element, record the transition, capture the new screen
   - Use `back` to return and explore the next path
3. Build the nav map in `.maestro/nav-map.md` using the standard format
4. Mark any screens behind auth/login with 🔐
5. Mark screens it couldn't reach with ⚠️ unexplored
6. Delete `.maestro/.nav-map-stale` sentinel if it exists

After crawling, present the map to the user with:
> ℹ️ This is an auto-discovered map. Please review and edit `.maestro/nav-map.md`
> to fix any missed screens, add auth-gated flows, or correct navigation paths.

### `view` — Show current map
Read and display `.maestro/nav-map.md`. If a feature name is given
(e.g., `/deguster:map view checkout`), show only the relevant section
and its full path from root.

### `update <section>` — Update a section
Spawn an **app-crawler** subagent (Sonnet) to re-crawl only the specified
section of the app. Merge results into the existing nav map, preserving
manually-edited sections. Show a diff of what changed.
Delete `.maestro/.nav-map-stale` sentinel on completion.

### `add <feature> <path description>` — Manually add entry
Parse the natural language path and add it to both the tree and the
feature index in `.maestro/nav-map.md`.
