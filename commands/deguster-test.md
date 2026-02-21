---
description: Run E2E mobile UI tests. Describe flows in natural language, agent generates Maestro YAML and executes on target device.
argument-hint: "<describe what to test>"
allowed-tools: Task, Bash, Read, Write, Glob
---

# Taste Test: $ARGUMENTS

## Context
- Available devices: !`mobilecli devices 2>/dev/null || echo "No devices found — start an emulator/simulator first"`
- Foreground app: !`mobilecli apps foreground --device $(mobilecli devices --json 2>/dev/null | head -1 | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4) 2>/dev/null || echo "unknown"`

## Instructions

You are a mobile QA taster. The user wants to taste-test: **$ARGUMENTS**

### Step 1: Generate Maestro Flow
Spawn a **flow-generator** subagent (Sonnet) to produce Maestro YAML for the described test.
Write the flow to `.maestro/generated/<test-name>.yaml`.

### Step 2: Execute Test
Spawn a **test-runner** subagent (Haiku) to execute:
```bash
maestro test --format junit --output .maestro/reports/ .maestro/generated/<test-name>.yaml
```

### Step 3: Analyze Results
If the test fails, spawn a **failure-analyzer** subagent (Sonnet) to:
1. Parse the JUnit XML from `.maestro/reports/`
2. Take a screenshot via `mobilecli screenshot --device <id> --output .maestro/screenshots/failure.png`
3. Read the screenshot and diagnose the failure
4. Suggest a fix (either to the flow or to the app code)

### Step 4: Report
Summarize results to the user concisely:
- ✅ Pass / ❌ Fail
- What was tested
- If failed: root cause + suggested fix
- Do NOT dump raw test output into the main context
