# /setup-worktree — Create Git Worktree for Parallel Work

Create a git worktree for working on a separate branch in parallel.

## Usage

Ask the user:
1. Branch name for the new worktree
2. Base branch (default: main)

## Process

1. **Create worktree**:
   ```bash
   git worktree add ../PROJECT_NAME-BRANCH_NAME -b BRANCH_NAME
   ```

2. **Copy Claude config to worktree**:
   ```bash
   cp -r .claude/ ../PROJECT_NAME-BRANCH_NAME/.claude/
   cp CLAUDE.md ../PROJECT_NAME-BRANCH_NAME/CLAUDE.md
   ```

3. **Create fresh log directories**:
   ```bash
   mkdir -p ../PROJECT_NAME-BRANCH_NAME/.claude/logs/{sessions,agents,progress,reviews,prompt-trails}
   ```

4. **Report**:
   - Worktree path
   - Branch name
   - How to start Claude in the worktree:
     ```bash
     cd ../PROJECT_NAME-BRANCH_NAME && claude
     ```

## Notes

- Each worktree gets its OWN `.claude/logs/` — separate from main.
- The agent counter (`.claude/logs/.agent-counter`) starts fresh in each worktree.
- To list active worktrees: `git worktree list`
- To remove a worktree: `git worktree remove ../PROJECT_NAME-BRANCH_NAME`
