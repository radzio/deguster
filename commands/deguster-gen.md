---
description: Generate Maestro YAML test flows from natural language descriptions. Does not execute — just writes files.
argument-hint: "<describe the flow to generate>"
allowed-tools: Task, Bash, Read, Write, Glob
---

# Generate Recipe: $ARGUMENTS

## Instructions

Spawn a **flow-generator** subagent (Sonnet) to:

1. Parse the user's description: **$ARGUMENTS**
2. Determine the target platform (iOS/Android/Web) and appId
3. Generate valid Maestro YAML using the maestro-syntax skill
4. Write to `.maestro/flows/<descriptive-name>.yaml`
5. If the flow needs shared login or setup steps, generate those as
   separate files and use `runFlow:` references

### Output Format
Return to the user:
- The file path(s) created
- A brief summary of what the flow tests
- How to run it: `maestro test .maestro/flows/<n>.yaml`

### Quality Rules
- Use `assertVisible` / `assertNotVisible` for verifications
- Prefer text-based selectors over coordinates
- Use `extendedWaitUntil` for async operations, never `sleep`
- Add `label:` to key steps for readable reports
- Do NOT use `assertWithAI` or `assertNoDefectsWithAi` unless the user explicitly requests AI-powered assertions
