---
name: flow-registry
description: Defines the flow registry format and update rules. Auto-loads when generating, analyzing, or managing Maestro flows so agents keep the registry in sync.
---

## Flow Registry Format

The flow registry lives at `.maestro/flow-registry.md`. It is a Markdown file with three sections:

1. **Flow Index** — one row per generated flow
2. **Coverage Matrix** — one row per feature from the nav map
3. **Shared Flows** — one row per shared flow referenced via `runFlow:`

Agents that create, update, or analyze flows must read this file before acting and write it back after making changes.

## Flow Index

| Column | Description |
|--------|-------------|
| Flow | Relative path from `.maestro/` (e.g., `flows/login.yaml`) |
| Features | Comma-separated feature names matching nav map Feature Index |
| Screens | Comma-separated screen names visited during the flow |
| Depends On | Shared flows referenced via `runFlow:` (or `—` if none) |
| Tags | Comma-separated tags (smoke, regression, negative, auth, etc.) |
| Generated | Date the flow was created (YYYY-MM-DD) |

## Coverage Matrix

| Column | Description |
|--------|-------------|
| Feature | Feature name from nav map |
| Flows | Comma-separated flow filenames that test this feature (or `—`) |
| Coverage | `✅ N flows` or `⚠️ uncovered` |

## Shared Flows

| Column | Description |
|--------|-------------|
| Shared Flow | Path relative to `.maestro/` |
| Used By | Comma-separated flow filenames that reference it via `runFlow:` |

## Update Rules

### When creating a flow (flow-generator)

1. Read `.maestro/flow-registry.md` (create from template if missing)
2. Add a new row to **Flow Index** for the generated flow
3. Scan the flow YAML for `runFlow:` references — update **Shared Flows** (add new rows or append to Used By)
4. Rebuild **Coverage Matrix** from the current Flow Index + nav map Feature Index
5. Write the updated registry back to disk
6. Delete `.registry-stale` if it exists

### When updating the nav map (app-crawler)

1. Read `.maestro/flow-registry.md` (skip silently if the file doesn't exist)
2. Rebuild **Coverage Matrix** only — match nav map features against Flow Index
3. Do **not** touch Flow Index or Shared Flows
4. Write the updated registry back to disk

### When analyzing failures (failure-analyzer)

1. Read `.maestro/flow-registry.md` (skip silently if the file doesn't exist)
2. For each row in **Flow Index**, check that the flow file exists on disk
3. Report any missing flow files so the user can regenerate or remove stale entries

## Creating a New Registry

When the registry file doesn't exist yet, create it with empty tables:

```markdown
# Flow Registry

## Flow Index
| Flow | Features | Screens | Depends On | Tags | Generated |
|------|----------|---------|------------|------|-----------|

## Coverage Matrix
| Feature | Flows | Coverage |
|---------|-------|----------|

## Shared Flows
| Shared Flow | Used By |
|-------------|---------|
```

Then populate:
- **Coverage Matrix** — fill from the nav map Feature Index (one row per feature, all marked `⚠️ uncovered` initially)
- **Flow Index** and **Shared Flows** — fill from any existing `.maestro/flows/` YAML files found on disk
