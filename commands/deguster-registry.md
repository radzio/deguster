---
description: View flow coverage or rebuild the flow registry from existing flows and nav map.
argument-hint: "<view [feature] | rebuild>"
allowed-tools: Task, Bash, Read, Write, Glob
---

# Flow Registry: $ARGUMENTS

## Context
- Registry: !`cat .maestro/flow-registry.md 2>/dev/null || echo "No flow registry found. Run /deguster:registry rebuild to create one."`
- Existing flows: !`ls .maestro/flows/ .maestro/shared/ 2>/dev/null || echo "No flows found"`

## Instructions

Parse $ARGUMENTS to determine the action:

### `view` — Show full registry
Read and display `.maestro/flow-registry.md`. Highlight uncovered features.
If a feature name is given (e.g., `/deguster:registry view checkout`), show only that feature's coverage details and the flows that test it.

### `rebuild` — Full rescan and rebuild
Rebuild the entire flow registry from scratch:
1. Scan `.maestro/flows/` and `.maestro/shared/` for all YAML flow files
2. For each flow file, parse:
   - `runFlow:` references → Shared Flows + Depends On
   - `appId:` → determine the app
   - Key actions (tapOn, assertVisible) → infer screens visited
3. Read `.maestro/nav-map.md` Feature Index (if exists) to build Coverage Matrix
4. Write the complete `.maestro/flow-registry.md` with all three sections
5. Delete `.maestro/.registry-stale` sentinel if it exists

After rebuilding, show a summary:
- Total flows registered
- Features covered vs uncovered
- Shared flow dependency count
