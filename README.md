# 🍷 deguster

> *Déguster: to taste carefully, to savor.* Taste your mobile app before serving it to users.

A Claude Code plugin for mobile UI testing via **Maestro CLI** and **mobilecli**.
No MCP servers, no daemons. Claude orchestrates, CLI tools execute.

Part of [plugin-patisserie](https://github.com/radzio/plugin-patisserie).

## Commands

| Command | Description |
|---------|-------------|
| `/deguster:test <description>` | E2E test from natural language |
| `/deguster:parity <targets>` | Cross-platform iOS vs Android comparison |
| `/deguster:gen <description>` | Generate Maestro YAML flows (no execution) |
| `/deguster:regression [folder]` | Run full suite + AI failure analysis |
| `/deguster:devices [action]` | List & manage connected devices |
| `/deguster:map <action>` | Discover, view, update app navigation map |
| `/deguster:registry <action>` | View flow coverage or rebuild the flow registry |

## Prerequisites

```bash
# Maestro CLI
curl -Ls 'https://get.maestro.mobile.dev' | bash

# mobilecli
npm install -g @mobilenext/mobilecli
```

## Install

```bash
claude plugin marketplace add radzio/plugin-patisserie
claude plugin install deguster@radzio-patisserie
```

## Quick Start

```bash
# 1. Map your app
/deguster:map discover com.example.myapp

# 2. Generate a test
/deguster:gen "login with invalid email shows error message"

# 3. Run it
/deguster:test login with invalid email shows error

# 4. Run the full suite
/deguster:regression

# 5. Compare platforms
/deguster:parity com.myapp on iPhone-16 vs Pixel-9 — test checkout
```

## Architecture

```
Slash command → Agent → Subagent → CLI tool
                        │               ├── maestro test / hierarchy
                        │               └── mobilecli screenshot / devices / apps
                        │
                        ├── Sonnet: flow-generator, failure-analyzer, visual-comparator, app-crawler
                        └── Haiku:  test-runner, device-inspector
```

All CLI-based. No MCP. Subagents isolate verbose output from main context.

## License

MIT
