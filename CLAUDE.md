# deguster — Mobile UI Testing Plugin

Claude Code plugin for mobile UI testing via Maestro CLI and mobilecli. Part of `radzio/plugin-patisserie`.

## Architecture

**CLI-based, no MCP.** Commands spawn subagents that call CLI tools via Bash.

```
Slash command → Agent (Sonnet/Haiku) → CLI tool (maestro/mobilecli)
```

### Model tiers
- **Sonnet** (`claude-sonnet-4-5-20250929`): flow-generator, failure-analyzer, visual-comparator, app-crawler — reasoning-heavy
- **Haiku** (`claude-haiku-4-5-20251001`): test-runner, device-inspector — mechanical execution

### External dependencies
- `maestro` — Maestro CLI for test execution and view hierarchy
- `mobilecli` — device management, screenshots, app lifecycle

## Project structure

```
deguster/
├── .claude-plugin/plugin.json    # plugin manifest
├── commands/                     # 6 slash commands (deguster:test, gen, parity, regression, devices, map)
├── agents/                       # 6 subagents (flow-generator, test-runner, failure-analyzer, visual-comparator, app-crawler, device-inspector)
├── hooks/
│   ├── hooks.json                # 3 hooks: PreToolUse, PostToolUse, Stop
│   └── scripts/                  # shell scripts for hook logic
├── skills/
│   ├── maestro-syntax/           # Maestro YAML reference + 4 example flows
│   └── nav-map/                  # auto-loads nav map for flow generation
├── README.md
└── .gitignore
```

## Key design rules

### Maestro flows
- Always start with `appId:` header and `---` separator
- Run `maestro hierarchy` before generating — never guess selectors
- Selector priority: text > accessibility ID > CSS-style > coordinates (last resort)
- Use `extendedWaitUntil` instead of `sleep`
- Use `runFlow:` for shared setup (login, onboarding) — no monolithic flows
- Add `label:` on critical steps for readable reports
- Assert after every significant action
- **NO `assertWithAI` / `assertNoDefectsWithAi`** unless user explicitly requests it

### Nav map (`.maestro/nav-map.md`)
- Two sections: Screen Tree (indented hierarchy) + Feature Index (flat lookup table)
- Lines marked `<!-- manual -->` are never overwritten by re-crawl
- Auth-gated screens marked with 🔐, unreachable with ⚠️
- flow-generator always reads nav map first before generating

### Hooks philosophy
Hooks are cheap signals, not expensive automated actions:
- `check-nav-map-staleness.sh` (PostToolUse): appends to `.maestro/.nav-map-stale` sentinel when UI files change
- `suggest-map-update.sh` (Stop): reminds user if sentinel exists
- `auto-approve-maestro.sh` (PreToolUse): auto-approves safe read-only CLI commands

### Subagent rules
- Haiku agents: never dump raw logs, always return structured summaries
- Sonnet agents: always introspect live app before generating/analyzing
- All agents: keep output concise, isolate verbose CLI output from main context

## File conventions

- Commands: `commands/deguster-<name>.md` with YAML frontmatter (`description`, `allowed-tools`)
- Agents: `agents/<name>.md` with YAML frontmatter (`description`, `model`, `allowed-tools`)
- Skills: `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description`)
- Hook scripts: `hooks/scripts/<name>.sh` — read JSON from stdin, output JSON to stdout
- Maestro examples: `skills/maestro-syntax/examples/<name>.yaml`

## Runtime artifacts (gitignored)

- `.maestro/.nav-map-stale` — staleness sentinel file
- `.maestro/screenshots/` — captured device screenshots
- `.maestro/reports/` — JUnit XML test reports
- `.maestro/generated/` — auto-generated Maestro flows

## Failure classification taxonomy

Used by failure-analyzer when diagnosing test failures:
- **App Regression**: element removed/renamed, flow broken by code change
- **Test Drift**: app updated legitimately, test needs updating
- **Flaky**: timing issue, network dependency, animation interference
- **Environment**: device state, permissions, missing test data

## Parity severity levels

Used by visual-comparator for cross-platform comparison:
- 🔴 Critical: missing interactive elements, broken navigation
- 🟡 Warning: visual inconsistencies (spacing, fonts, colors)
- ⚪ Info: platform-appropriate differences (iOS back gesture vs Android back button)
