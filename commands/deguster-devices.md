---
description: List connected devices, boot simulators/emulators, check device status.
argument-hint: "[list | screenshot | boot | apps | launch]"
allowed-tools: Bash
---

# Kitchen Equipment: $ARGUMENTS

Run the appropriate mobilecli commands based on the user's request:

- **List**: `mobilecli devices` (online only) or `mobilecli devices --include-off` (all)
- **Screenshot**: `mobilecli screenshot --device <id> --output screenshot.png`
- **Boot**: `mobilecli devices boot <device-name>`
- **Apps**: `mobilecli apps list --device <id>`
- **Foreground**: `mobilecli apps foreground --device <id>`
- **Launch**: `mobilecli apps launch <bundle-id> --device <id>`

Present results in a clean table format.
