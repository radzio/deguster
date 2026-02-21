---
description: Run full Maestro test suite and analyze failures with AI. Generates actionable report.
allowed-tools: Task, Bash, Read, Write, Glob
---

# Full Tasting Menu: $ARGUMENTS

## Context
- Test directory: !`ls .maestro/flows/ 2>/dev/null || echo "No flows found in .maestro/flows/"`

## Instructions

### Step 1: Run Suite
Spawn a **test-runner** subagent (Haiku):
```bash
maestro test --format junit --output .maestro/reports/ .maestro/flows/
```

### Step 2: Parse Results
Spawn a **failure-analyzer** subagent (Sonnet) to:
1. Parse `.maestro/reports/report.xml`
2. For each failure:
   - Extract the failing step and error message
   - Take a screenshot of current device state
   - Classify: flaky vs real regression vs test-needs-update
3. Group failures by root cause

### Step 3: Report
Present a summary:

| Flow | Status | Issue | Classification |
|------|--------|-------|----------------|
| login.yaml | ❌ | "Login" button not found | 🔴 App regression |
| checkout.yaml | ❌ | Timeout on payment screen | 🟡 Likely flaky |
| profile.yaml | ✅ | — | — |

For each real regression, suggest:
- Which app code likely changed
- What the fix might be
