# /fresh-eyes — Run Fresh Eyes Validation Review

Invoke the @fresh-eyes agent to perform a comprehensive validation of all changes in the current task.

## Instructions

1. Use the Task tool to spawn a fresh-eyes agent:
   ```
   Task(subagent_type="fresh-eyes", prompt="Review all changes since the last merge/main branch. Check: completeness, quality, tests, integration, security. See your agent definition for the full checklist. Run tests, check git diff, and read logs in .claude/logs/. Output a detailed review report.")
   ```

2. The agent will:
   - Read `git diff main...HEAD` to see all changes
   - Read through changed files
   - Run the test suite
   - Check `.claude/logs/` for agent reports
   - Use Puppeteer to screenshot UI if frontend changed
   - Produce a validation report

3. Save the report to `.claude/logs/reviews/YYYY-MM-DD_fresh-eyes_topic.md`

4. Present the verdict to the user:
   - **APPROVED**: All good, ready to merge
   - **NEEDS_FIXES**: List specific issues to address
   - **MAJOR_ISSUES**: Significant problems found, discuss with user
