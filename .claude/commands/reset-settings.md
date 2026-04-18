# /reset-settings — Reset Claude Settings to Template Defaults

This command resets the Claude Code configuration to the template defaults. Use when settings get corrupted or overwritten.

## What It Does

1. **Backs up current settings**:
   ```bash
   cp ~/.claude/settings.json ~/.claude/settings.json.bak.$(date +%Y%m%d_%H%M%S)
   cp .claude/settings.json .claude/settings.json.bak.$(date +%Y%m%d_%H%M%S) 2>/dev/null
   ```

2. **Restores global settings** by running the reset script from the template directory

3. **Restores project settings** from the template's `.claude/settings.json`

4. **Verifies hooks are executable**:
   ```bash
   chmod +x .claude/hooks/*.sh
   ```

5. **Reports what was changed**:
   - Settings that were restored
   - MCPs that are now configured
   - Permissions that are now set
   - Hooks that are now active

## Instructions

Find and run the reset script from the template directory (wherever it was cloned):
```bash
# If the template is a sibling or parent, adjust the path accordingly
./scripts/reset-claude-settings.sh
```

Then verify by checking:
- `~/.claude/settings.json` — global settings
- `.claude/settings.json` — project settings
- `.claude/hooks/*.sh` — hook scripts are executable

Report the result to the user with a summary of what was restored.
