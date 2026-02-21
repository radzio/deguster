---
name: maestro-syntax
description: Maestro YAML flow syntax, command reference, and mobile testing patterns. Auto-loads when generating or editing Maestro test flows.
---

## Maestro Flow Structure
Every flow starts with a config header and `---` separator:
```yaml
appId: com.example.app
tags:
  - smoke
  - login
---
# commands follow
```

## Essential Commands
| Command | Purpose | Example |
|---------|---------|---------|
| launchApp | Start/restart app | `- launchApp` |
| tapOn | Tap element | `- tapOn: "Submit"` |
| inputText | Type text | `- inputText: "user@test.com"` |
| assertVisible | Verify on screen | `- assertVisible: "Welcome"` |
| assertNotVisible | Verify absent | `- assertNotVisible: "Error"` |
| assertTrue | Value assertion | `- assertTrue: "${output.x == 'y'}"` |
| swipe | Swipe gesture | `- swipe: { direction: LEFT }` |
| scroll | Scroll down | `- scroll` |
| back | Device back | `- back` |
| runFlow | Reuse sub-flow | `- runFlow: login.yaml` |
| copyTextFrom | Extract text | `- copyTextFrom: { id: "price" }` |
| extendedWaitUntil | Wait for element | `- extendedWaitUntil: { visible: "Ready", timeout: 5000 }` |

## Selector Priority (most to least resilient)
1. Text content: `tapOn: "Submit Order"`
2. Accessibility id: `tapOn: { id: "submit-btn" }`
3. CSS-style: `tapOn: { text: "Submit", index: 0 }`
4. Point coordinates (last resort): `tapOn: { point: "50%,80%" }`

## Anti-Patterns
- ❌ `sleep: 3000` → ✅ `extendedWaitUntil: { visible: "...", timeout: 5000 }`
- ❌ Hardcoded coordinates → ✅ Text or ID selectors
- ❌ Monolithic 200-step flows → ✅ `runFlow:` composition
- ❌ No assertions → ✅ Assert after every significant action
- ❌ Guessing selectors → ✅ Run `maestro hierarchy` to discover real elements

## Introspection First
Before writing flows, always inspect the live app:
```bash
maestro hierarchy    # dump current screen's view tree with IDs and text
```
Use discovered element text/IDs as selectors. Never guess.
