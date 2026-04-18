---
name: prompt-trail-creator
description: Generate implementation plans and prompt trails for development tasks. Triggers on task planning, implementation planning, prompt generation, feature planning, sprint planning.
---

# Prompt Trail Creator

Transform a task description into a structured prompt trail — a series of self-contained prompt files that agents follow sequentially to implement a complete feature.

## When This Skill Applies

- User wants to plan a new feature or task
- User says "plan", "prompt trail", "implementation plan", "let's build", "create a plan for"
- User invokes `/prompt-trail-creator`

## Overview

This skill implements a 3-phase workflow:

1. **Discovery** — Explore code, ask questions, build understanding
2. **Architecture** — Design the solution, assign agents, select tools
3. **Generation** — Create the prompt trail files

## Phase 1: Discovery

### Step 1.1: Explore Existing Code
If a codebase exists, use the Explore agent to map:
- Project structure (directories, key files)
- Existing patterns (how similar features were built)
- Test structure (where tests live, what framework)
- Database schema (if applicable)
- Frontend component structure (if applicable)

### Step 1.2: Ask Clarifying Questions
Present 2-5 questions to the user with proposed answer options:
- What is the scope? (specific feature vs broad change)
- What are the acceptance criteria?
- Are there integration points with existing code?
- Is this long-running (multi-session) or short-running (single session)?
- Any specific constraints? (performance, backwards compatibility, etc.)

### Step 1.3: Confirm Understanding
Summarize back to the user:
- "Here's what I understand you want to build..."
- List components, constraints, success criteria
- Get explicit "yes" before proceeding

## Phase 2: Architecture

### Step 2.1: Design Component Breakdown
- List all files/modules that need to be created or modified
- Identify dependencies between components
- Map to backend vs frontend vs shared

### Step 2.2: Assign Agents
For each component, assign the appropriate agent:
- `backend-dev` for Python/FastAPI code
- `frontend-dev` for TypeScript/React code
- `integration-check` after multi-file changes
- `reviewer` before merge
- `code-sentinel` for security-sensitive code
- `fresh-eyes` at the end of long-running tasks
- `mermaid-architect` for final documentation

### Step 2.3: Select Tools & MCPs
For each step, determine required tools:
- **Supabase MCP**: If database operations needed
- **Puppeteer MCP**: If frontend visual verification needed
- **GitHub MCP**: If PR operations needed
- **Perplexity MCP**: If research/documentation lookup needed
- **Bash**: For running tests, migrations, builds
- **DeepWiki MCP**: For library/framework documentation

### Step 2.4: Present Architecture
Show the user:
- Component map
- Agent pipeline with dependencies
- Tool/MCP requirements per step
- Estimated step count

Get approval before generating files.

## Phase 3: Generation

### Step 3.1: Create Prompt Trail Directory
```
.claude/logs/prompt-trails/YYYY-MM-DD_topic/
```

### Step 3.2: Generate Masterplan
Create `00_masterplan.md` with:
- Goal, architecture decisions, component map
- Agent pipeline table
- Success criteria checklist
- Task type tag (long-running / short-running)

### Step 3.3: Generate Step Files
For each step (01 through NN), create `NN_step-name.md` with:
- Agent assignment
- Dependencies (which steps must be complete)
- Next step pointer
- Detailed implementation instructions
- Files to create/modify with specific content guidance
- Schemas/interfaces (if applicable)
- Validation commands (test commands to verify the step)
- Commit message template

### Step 3.4: Generate Validation Step
Create final `NN_validation.md` that:
- Invokes @fresh-eyes for final review
- Invokes @integration-check for wiring verification
- Invokes @mermaid-architect for documentation
- Summarizes results

## Output

Report to user:
- Prompt trail location
- Number of steps
- Estimated complexity
- How to start: "Run step 01 by reading `.claude/logs/prompt-trails/YYYY-MM-DD_topic/01_xxx.md`"
