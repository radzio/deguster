---
name: nav-map
description: Loads the app navigation map when generating or editing Maestro flows. Provides screen paths, auth requirements, and shared flow references so the flow-generator knows how to reach any feature.
---

## Auto-loaded Context
When this skill activates, read `.maestro/nav-map.md` and use it to:

1. **Look up the feature** in the Feature Index table
2. **Check auth requirement**: if Auth? = Yes, prepend `runFlow: shared/login.yaml`
3. **Follow the path**: convert the Path column into Maestro steps
4. **Then add the test-specific steps** the user requested

## Example: Generating a test for "edit profile photo"

Feature Index lookup:
| Feature | Auth? | Path |
|---------|-------|------|
| Change Photo | Yes | Launch → Tab "Profile" → Tap "Edit Profile" → Tap "Change Photo" |

Generated flow:
```yaml
appId: com.example.myapp
---
- launchApp
- runFlow: shared/login.yaml
- tapOn: "Profile"
- tapOn: "Edit Profile"
- tapOn: "Change Photo"
# ... test-specific steps follow
```

## When Nav Map is Missing
If `.maestro/nav-map.md` doesn't exist, warn the user:
> ⚠️ No nav map found. Run `/deguster:map discover <appId>` first, or I'll
> need to explore the app live (slower and less reliable).

Then fall back to using `maestro hierarchy` for live exploration.

## Keeping the Map Updated
After generating flows for a screen not yet in the map, suggest:
> 💡 Screen "New Screen" isn't in the nav map yet. Want me to add it?
> Run `/deguster:map add "Feature Name" "path description"` to update.
