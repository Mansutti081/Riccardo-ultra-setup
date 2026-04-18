# /create-skill — Generate a New Skill On Demand

You generate new Claude Code skills based on the user's description.

## Process

1. **Ask**: What should this skill do? Get a clear description from the user.

2. **Design**: Based on the description, determine:
   - Skill name (kebab-case)
   - Trigger keywords (for auto-detection)
   - Sub-skills needed (if any)
   - Tools/MCPs the skill needs
   - Whether it needs a hook configuration

3. **Generate files**:

   a. Main skill file: `.claude/skills/{skill-name}/SKILL.md`
   ```markdown
   ---
   name: skill-name
   description: When this skill applies (keywords for auto-detection)
   ---

   # Skill Name

   ## Overview
   [What this skill does]

   ## When This Skill Applies
   [Trigger scenarios]

   ## Workflow
   [Step-by-step process]
   ```

   b. Sub-skill files if needed: `.claude/skills/{skill-name}/{sub-skill}/SKILL.md`

   c. Reference files if needed: `.claude/skills/{skill-name}/references/*.md`

4. **Install**: Copy the skill to the active project's `.claude/skills/` directory.

5. **Update CLAUDE.md**: Add the skill to the slash commands table.

6. **Test**: Verify the skill loads by asking Claude to invoke it.

## Skill Design Principles

- Each step should take 2-5 minutes
- Include validation/verification at the end
- Reference specific file paths, not vague descriptions
- Include code examples where applicable
- Make auto-detection keywords specific enough to avoid false triggers

## Output

Report to the user:
- Skill name and location
- How to invoke it (slash command or auto-detected keywords)
- What it does step by step
