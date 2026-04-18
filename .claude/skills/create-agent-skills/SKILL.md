---
name: create-agent-skills
description: Generate new Claude Code skills and agent definitions on demand. Triggers on create skill, new skill, add skill, generate skill, build a skill.
---

# Create Agent Skills

Generate new Claude Code skills with proper structure, frontmatter, and integration.

## When This Skill Applies

- User wants to create a new custom skill
- User says "create a skill for", "I need a skill that", "build a skill"
- User invokes `/create-skill`

## Workflow

### Step 1: Gather Requirements
Ask the user:
- What should this skill do?
- When should it auto-trigger? (keywords)
- Does it need sub-skills?
- What tools/MCPs does it need?

### Step 2: Design Skill Structure
Determine:
- Skill name (kebab-case, descriptive)
- Description (for auto-detection matching)
- Sub-skills (if workflow has distinct phases)
- Reference files (if skill needs context docs)

### Step 3: Generate Files

Main skill: `.claude/skills/{name}/SKILL.md`

```markdown
---
name: {skill-name}
description: {when this skill applies — keywords for auto-detection}
---

# {Skill Name}

## Overview
{What this skill does}

## When This Skill Applies
{Specific trigger scenarios}

## Workflow
{Step-by-step process}

## Validation
{How to verify the skill worked}
```

Sub-skills (if needed): `.claude/skills/{name}/{sub-skill}/SKILL.md`

Reference files (if needed): `.claude/skills/{name}/references/*.md`

### Step 4: Install
Copy to active project's `.claude/skills/` directory.

### Step 5: Test
Verify auto-detection works by mentioning trigger keywords.

## Skill Design Best Practices

From the 2389-research claude-plugins reference:

1. **Granular checklists** — Each task 2-5 minutes
2. **Complete code examples** — Show exact code, not descriptions
3. **Exact file paths** — Never vague references
4. **Auto-detection** — Frontmatter description enables keyword matching
5. **TodoWrite integration** — Use TodoWrite for task tracking within skills
6. **Validation steps** — Every skill should verify its own output
