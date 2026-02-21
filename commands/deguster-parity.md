---
description: Compare app behavior across iOS and Android (or two versions). Spawns parallel agents testing both platforms side-by-side.
argument-hint: "<app on device-A vs device-B — flow to compare>"
allowed-tools: Task, Bash, Read, Write, Glob
---

# Parity Tasting: $ARGUMENTS

## Context
- Available devices: !`mobilecli devices 2>/dev/null`

## Instructions

You are comparing mobile app flavor across platforms or versions.
Input: **$ARGUMENTS** (expects two app identifiers or device targets)

### Step 1: Identify Targets
Parse $ARGUMENTS to identify:
- Platform A (e.g., iOS simulator) and Platform B (e.g., Android emulator)
- OR Version A and Version B on the same platform
- The flows/screens to compare

### Step 2: Parallel Execution
Spawn **two test-runner subagents in parallel** (Haiku), one per target:

Each agent:
1. Uses `mobilecli screenshot --device <device-id>` to capture key screens
2. Runs `maestro test` for the same flow on their respective device
3. Uses `maestro hierarchy` to dump the view hierarchy
4. Captures screenshots at each major step

### Step 3: Visual Comparison
Spawn a **visual-comparator** subagent (Sonnet) to:
1. Compare screenshots from both platforms
2. Compare view hierarchies for structural differences
3. Flag: missing elements, layout shifts, text truncation, color mismatches

### Step 4: Parity Report
Summarize with severity levels:
- 🔴 Critical: Functional differences (missing buttons, broken flows)
- 🟡 Warning: Visual differences (spacing, fonts, colors)
- 🟢 Matching: Screens that pass parity check
