# Riccardo-ultra-setup

A self-orchestrating Claude Code agent framework — predefined agents, skills, hooks, slash commands, and rule packs, ready to drop into any project.

---

## Table of Contents

- [What's in the box](#whats-in-the-box)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Repository Structure](#repository-structure)
- [Configuration](#configuration)
  - [1. Personalize `CLAUDE.md`](#1-personalize-claudemd)
  - [2. Review `.claude/settings.json`](#2-review-claudesettingsjson)
  - [3. (Optional) Configure MCP servers globally](#3-optional-configure-mcp-servers-globally)
- [Deploying to a Project](#deploying-to-a-project)
- [Usage](#usage)
  - [Slash Commands](#slash-commands)
  - [Agent Roster](#agent-roster)
  - [Skills](#skills)
  - [Rules](#rules)
  - [Hooks](#hooks)
  - [Logging](#logging)
- [Working with Prompt Trails](#working-with-prompt-trails)
- [Customization](#customization)
- [WhatsApp MCP — Security Rules](#whatsapp-mcp--security-rules)
- [License](#license)

---

## What's in the box

This repo ships a complete `.claude/` directory plus a master `CLAUDE.md`. Everything is plain markdown + shell — no build step, no runtime dependencies.

- **9 specialist agents** — backend, frontend, debug, review, security, integration, logging, diagrams, validation
- **5 slash commands** — planning, validation, skill generation, settings reset, worktree setup
- **7 skills** — auto-detected coding patterns (TDD, security review, API design, frontend patterns, coding standards…)
- **4 event hooks** — session start, pre/post tool use, subagent stop
- **Rule packs** — `common/` (language-agnostic) and `typescript/` (TS-specific) guidelines
- **Centralized logging** — everything lands in `.claude/logs/` with dated filenames

---

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) (v2.1+)
- Bash-compatible shell (Linux or macOS)
- [Node.js](https://nodejs.org/) v18+ — only if you want to use MCP servers via `npx`

Optional:
- `jq` — used by some helper workflows
- `tmux` — for multi-window dev sessions

---

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/<your-username>/Riccardo-ultra-setup.git
cd Riccardo-ultra-setup

# 2. Install into your project (one command)
./setup.sh /path/to/your/project

# 3. Open Claude Code in your project
cd /path/to/your/project
claude
```

The `setup.sh` installer copies `.claude/` and `CLAUDE.md` into the target directory, prepares `.claude/logs/`, makes the hook scripts executable, and prints a success message when it's done.

> Don't have a target project yet? You can also just run `claude` directly inside this repo — `.claude/` and `CLAUDE.md` are picked up automatically.

---

## Repository Structure

```
Riccardo-ultra-setup/
├── README.md                              # This file
├── CLAUDE.md                              # Master project instructions
├── setup.sh                               # One-command installer (deploy to any project)
├── .gitignore
└── .claude/
    ├── settings.json                      # Hook configuration
    ├── agents/                            # 9 specialist agents
    │   ├── archivist.md                   #   Logging & knowledge management
    │   ├── backend-dev.md                 #   Python/FastAPI specialist
    │   ├── code-sentinel.md               #   Security audit (report-only)
    │   ├── debug.md                       #   Deep-dive debugging
    │   ├── fresh-eyes.md                  #   Final validation (zero context)
    │   ├── frontend-dev.md                #   TypeScript/React specialist
    │   ├── integration-check.md           #   Code wiring verification
    │   ├── mermaid-architect.md           #   Mermaid diagram generation
    │   └── reviewer.md                    #   Code quality review
    ├── commands/                          # 5 slash commands
    │   ├── prompt-trail-creator.md
    │   ├── fresh-eyes.md
    │   ├── create-skill.md
    │   ├── reset-settings.md
    │   └── setup-worktree.md
    ├── skills/                            # 7 auto-detected skills
    │   ├── api-design/SKILL.md
    │   ├── coding-standards/SKILL.md
    │   ├── create-agent-skills/SKILL.md
    │   ├── frontend-patterns/SKILL.md
    │   ├── prompt-trail-creator/SKILL.md
    │   ├── security-review/SKILL.md
    │   └── tdd-workflow/SKILL.md
    ├── hooks/                             # 4 event hooks
    │   ├── session-start.sh               #   Terminal title + session log
    │   ├── pre-tool-use.sh                #   Security gate
    │   ├── post-tool-use.sh               #   Edit audit trail
    │   └── subagent-stop.sh               #   Agent completion tracking
    ├── rules/                             # Coding/process rules
    │   ├── common/                        #   Language-agnostic
    │   │   ├── agents.md
    │   │   ├── code-review.md
    │   │   ├── coding-style.md
    │   │   ├── development-workflow.md
    │   │   ├── git-workflow.md
    │   │   ├── hooks.md
    │   │   ├── patterns.md
    │   │   ├── performance.md
    │   │   ├── security.md
    │   │   └── testing.md
    │   └── typescript/                    #   TS-specific overlays
    │       ├── coding-style.md
    │       ├── hooks.md
    │       ├── patterns.md
    │       ├── security.md
    │       └── testing.md
    └── logs/                              # Centralized logging (populated at runtime)
        ├── sessions/
        ├── agents/
        ├── progress/
        ├── reviews/
        └── prompt-trails/
```

---

## Configuration

### 1. Personalize `CLAUDE.md`

Open `CLAUDE.md` and fill in the placeholders at the top of the file:

| Placeholder | What to put |
|-------------|-------------|
| `"<Fill in>"` (casual) | The nickname Claude should use in informal chat |
| `"<Fill in>"` (formal) | Your formal name for official output |
| `"<Fill in>"` (delivery) | The name Claude uses when announcing completed work |

Then review the **Tech Stack** section and replace the remaining `<Fill in>` entries (database, deployment target, etc.) with your actual stack.

Everything else — agent roster, git protocol, decision framework, logging rules — is designed to work out of the box.

### 2. Review `.claude/settings.json`

This file wires the four hooks to their Claude Code events:

| Event | Hook | Purpose |
|-------|------|---------|
| `SessionStart` | `session-start.sh` | Sets terminal title, creates session log |
| `PreToolUse` (Edit/Write/Bash) | `pre-tool-use.sh` | Security gate — blocks hook-file edits, `rm -rf /`, `chmod 777`, `eval()` |
| `PostToolUse` (Edit/Write) | `post-tool-use.sh` | Appends every edit to `.claude/logs/.edit-log.jsonl` |
| `SubagentStop` | `subagent-stop.sh` | Logs agent completion + increments sequential counter |

No edits required unless you want to change behavior.

### 3. (Optional) Configure MCP servers globally

MCPs (Supabase, GitHub, DeepWiki, Perplexity, Puppeteer, Chrome DevTools, Slack, Render…) should be registered **globally** in `~/.claude/mcp.json` so every project gets them:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_..." }
    },
    "mcp-deepwiki": {
      "command": "npx",
      "args": ["-y", "mcp-deepwiki@latest"]
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    }
  }
}
```

Put secrets in `~/.zshenv` / `~/.bashrc` (e.g. `export GITHUB_TOKEN=...`) and reference them in `mcp.json`. After editing, restart Claude Code or run `/mcp` inside it to verify.

All MCPs are optional — the framework runs fine without any of them.

---

## Deploying to a Project

Use the bundled `setup.sh` installer. From the root of this repo:

```bash
./setup.sh /path/to/your/project
```

That's it. The script will:

| Step | Action |
|------|--------|
| 1 | Copy `.claude/` (agents, commands, skills, rules, hooks, `settings.json`) into the target |
| 2 | Copy `CLAUDE.md` into the target (never overwrites an existing one) |
| 3 | Create `.claude/logs/` with `sessions/`, `agents/`, `progress/`, `reviews/`, `prompt-trails/` subdirs and an empty `.gitkeep` |
| 4 | `chmod +x` all hook scripts |
| 5 | Append `.claude/logs/` to the target `.gitignore` if one exists |
| 6 | Print a colored success message reminding you to fill in `CLAUDE.md` |

**Safe to re-run.** When re-run on an existing target:

- Framework content (`agents/`, `commands/`, `skills/`, `rules/`) is always refreshed from this repo.
- Your user-customized files (hook scripts, `settings.json`, `CLAUDE.md`) are preserved and never overwritten.

### Examples

```bash
# Install into an existing project
./setup.sh ~/projects/my-app

# Install into a brand-new directory (created on the fly)
./setup.sh ~/projects/new-startup

# Show help
./setup.sh --help
```

### After install

Open `CLAUDE.md` in your project and fill in the `<Fill in>` placeholders (nickname, formal name, tech stack). Then run `claude` in that directory — all agents, commands, skills, and hooks are ready.

> Tip: treat this repo as your personal "golden master." When you improve an agent, skill, or rule here, just re-run `./setup.sh /path/to/project` on each project to sync the framework files (your per-project customizations stay intact).

---

## Usage

### Slash Commands

Type these inside Claude Code (available automatically once you're in a folder that contains this setup):

| Command | What it does |
|---------|--------------|
| `/prompt-trail-creator` | **The main planning command.** Explores the codebase, asks clarifying questions, and generates a numbered prompt trail with agent assignments and validation steps. Start here for any non-trivial task. |
| `/fresh-eyes` | Spawns the `@fresh-eyes` agent with zero prior context. Runs tests, reads the git diff, checks logs, screenshots UI. Returns `APPROVED` / `NEEDS_FIXES` / `MAJOR_ISSUES`. |
| `/create-skill` | Generates a new Claude Code skill interactively — asks what it should do, designs the file structure, installs it to `.claude/skills/`. |
| `/reset-settings` | Restores `.claude/settings.json` and hook files to the template defaults. Backs up current state first. Use when configs get corrupted. |
| `/setup-worktree` | Creates a git worktree for parallel branch work and copies the Claude config into it. |

### Agent Roster

Specialist subagents, each with a defined scope and output format. Invoke directly with `@agent-name` or let the prompt trail creator pick:

| Agent | Scope | Key behavior |
|-------|-------|--------------|
| `backend-dev` | Python / FastAPI | Async endpoints, Pydantic v2, Alembic migrations, pytest |
| `frontend-dev` | TypeScript / React | Vite, Tailwind + component CSS, Puppeteer visual checks |
| `debug` | Bug investigation | Max 5 hypothesis attempts, escalates if stuck |
| `reviewer` | Code review | CRITICAL/HIGH/MEDIUM/LOW findings — never modifies code |
| `integration-check` | Wiring verification | Detects orphaned files, dead imports, missing exports, circular risks |
| `code-sentinel` | Security audit | OWASP Top 10 + framework checks — report-only |
| `archivist` | Logging & knowledge | Maintains `.claude/logs/` + sequential agent counter |
| `fresh-eyes` | Final validation | Zero prior context — runs tests, reads diff, screenshots UI |
| `mermaid-architect` | Diagrams | Architecture, data flow, component, task flow |

Examples:

```
Use the @debug agent to investigate why /api/users returns 500.
Run @integration-check on the files I just created.
Run @code-sentinel on the authentication module.
Use @mermaid-architect to diagram the current system architecture.
```

### Skills

Skills auto-activate when their trigger keywords appear in your prompt. Located in `.claude/skills/`:

| Skill | Triggers on |
|-------|-------------|
| `prompt-trail-creator` | Task planning, implementation planning, sprint planning |
| `tdd-workflow` | Writing new features, fixing bugs, refactoring (enforces TDD + 80% coverage) |
| `security-review` | Authentication, user input, secrets, payment/API endpoints |
| `coding-standards` | Cross-project naming, readability, immutability, code-quality review |
| `api-design` | REST design — resource naming, status codes, pagination, errors |
| `frontend-patterns` | React / Next.js patterns, state, performance |
| `create-agent-skills` | Generating new skills / agent definitions on demand |

You don't need to invoke skills explicitly — Claude picks them up from context.

### Rules

Markdown rule packs that supplement `CLAUDE.md`:

- **`rules/common/`** — language-agnostic: agents, code review, coding style, dev workflow, git workflow, hooks, patterns, performance, security, testing
- **`rules/typescript/`** — overlays for TS projects: coding style, hooks (React), patterns, security, testing

These are loaded as project instructions — Claude reads them automatically when working in this folder.

### Hooks

| Hook | Trigger | What it does |
|------|---------|--------------|
| `session-start.sh` | `SessionStart` | Sets terminal title with emoji + project + date, creates session log |
| `pre-tool-use.sh` | `PreToolUse` (Edit/Write/Bash) | Blocks hook-file edits, `rm -rf /`, `chmod 777`, `eval()` |
| `post-tool-use.sh` | `PostToolUse` (Edit/Write) | Appends each edit to `.claude/logs/.edit-log.jsonl` |
| `subagent-stop.sh` | `SubagentStop` | Logs agent completion, increments `.agent-counter` |

> The pre-tool-use hook **blocks modification of hook files from inside Claude Code** (security). To edit a hook, do it in your terminal/editor, or run `/reset-settings` first.

### Logging

All logs go to `.claude/logs/` and are gitignored:

| Directory | Contents | Naming pattern |
|-----------|----------|----------------|
| `sessions/` | Session start/end notes | `YYYY-MM-DD_HHMM_topic.md` |
| `agents/` | Individual agent logs | `agent-NNN_YYYY-MM-DD_agent-type_topic.md` |
| `progress/` | Task progress | `YYYY-MM-DD_topic_progress.md` |
| `reviews/` | Code reviews, audits | `YYYY-MM-DD_review-type_topic.md` |
| `prompt-trails/` | Implementation plans | `YYYY-MM-DD_topic/00_masterplan.md`, `01_step.md`, … |

`.claude/logs/.agent-counter` tracks sequential agent numbers across sessions and never resets.

---

## Working with Prompt Trails

Prompt trails are the core workflow for complex, multi-file tasks.

**What they are:** numbered markdown files, each containing instructions for one agent to execute one step. Each step points to the next.

**Where they live:** `.claude/logs/prompt-trails/YYYY-MM-DD_topic/`

Example:

```
.claude/logs/prompt-trails/2026-04-18_user-dashboard/
├── 00_masterplan.md      # Goal, components, agent pipeline, success criteria
├── 01_backend-api.md     # @backend-dev: create API endpoints
├── 02_database.md        # @backend-dev: Alembic migrations
├── 03_frontend-ui.md     # @frontend-dev: build UI
├── 04_integration.md     # @integration-check: verify wiring
├── 05_review.md          # @reviewer: code quality
└── 06_validation.md      # @fresh-eyes: final validation + @mermaid-architect diagram
```

Each step file specifies: agent assignment, dependencies, implementation instructions, exact file paths, validation commands, commit message, next-step pointer.

Run a whole trail:

```
Read .claude/logs/prompt-trails/2026-04-18_user-dashboard/00_masterplan.md
and execute the trail starting from step 01.
```

Or one step at a time:

```
Execute step 03 from .claude/logs/prompt-trails/2026-04-18_user-dashboard/03_frontend-ui.md
```

---

## Customization

**Add a new agent** — create `.claude/agents/my-agent.md`:

```markdown
# My Agent — Description

You are a specialist in [domain].

## Rules
1. [Constraint 1]
2. [Constraint 2]

## Output Format
[Expected structure]
```

**Add a new skill** — create `.claude/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: Trigger keywords for auto-detection
---

# My Skill

## When this skill applies
[Trigger scenarios]

## Workflow
[Steps]
```

Or run `/create-skill` inside Claude Code to generate one interactively.

**Add a new slash command** — create `.claude/commands/my-command.md`:

```markdown
# /my-command — Short description

[Instructions for Claude when this command is invoked]
```

**Edit a hook** — do it from your terminal/editor (the pre-tool-use hook blocks hook-file edits from inside Claude Code for safety). Or run `/reset-settings` to restore defaults first.

---

## WhatsApp MCP — Security Rules

If you later wire up a WhatsApp MCP, the rules in `CLAUDE.md` apply:

- **Never** let Claude start/run the WhatsApp MCP server automatically.
- Sends are **only** allowed to the number set in `WHATSAPP_ALLOWED_RECIPIENT`.
- No group sends. No forwards. No profile/setting changes.
- Reading incoming messages is fine.

These are hard security boundaries with no exceptions. See the `# WhatsApp MCP — CRITICAL SECURITY RULES` block in `CLAUDE.md` for the full protocol.

---

## License

MIT — do whatever you want, no warranty.
