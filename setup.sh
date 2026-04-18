#!/usr/bin/env bash
# ABOUTME: Installer for the Riccardo-ultra-setup template.
# ABOUTME: Copies .claude/ and CLAUDE.md into a user project and prepares .claude/logs/.

set -euo pipefail

# ---------------------------------------------------------------------------
# Colors (disabled automatically when stdout is not a TTY)
# ---------------------------------------------------------------------------
if [ -t 1 ]; then
  BOLD=$'\033[1m'
  DIM=$'\033[2m'
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  YELLOW=$'\033[0;33m'
  BLUE=$'\033[0;34m'
  CYAN=$'\033[0;36m'
  MAGENTA=$'\033[0;35m'
  RESET=$'\033[0m'
else
  BOLD=""; DIM=""; RED=""; GREEN=""; YELLOW=""; BLUE=""; CYAN=""; MAGENTA=""; RESET=""
fi

info()  { printf "%s==>%s %s\n" "${CYAN}"   "${RESET}" "$*"; }
ok()    { printf "%s[OK]%s %s\n" "${GREEN}"  "${RESET}" "$*"; }
warn()  { printf "%s[!! ]%s %s\n" "${YELLOW}" "${RESET}" "$*"; }
fail()  { printf "%s[ERROR]%s %s\n" "${RED}" "${RESET}" "$*" >&2; }

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
print_usage() {
  cat <<USAGE
${BOLD}Riccardo-ultra-setup — Installer${RESET}

${BOLD}Usage:${RESET}
  ./setup.sh ${CYAN}<path-to-your-project>${RESET}

${BOLD}Example:${RESET}
  ./setup.sh ~/projects/my-new-app

${BOLD}What it does:${RESET}
  1. Copies .claude/ (agents, commands, skills, rules, hooks, settings) into your project
  2. Copies CLAUDE.md into your project (existing one is preserved)
  3. Creates .claude/logs/ with a .gitkeep
  4. Makes the hook scripts executable
  5. Adds .claude/logs/ to your project .gitignore (if one exists)
USAGE
}

# ---------------------------------------------------------------------------
# Arg parsing
# ---------------------------------------------------------------------------
if [ "$#" -eq 0 ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  print_usage
  exit 0
fi

TARGET_DIR_INPUT="$1"
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Validate template (this repo must contain .claude/ and CLAUDE.md)
# ---------------------------------------------------------------------------
if [ ! -d "$TEMPLATE_DIR/.claude" ] || [ ! -f "$TEMPLATE_DIR/CLAUDE.md" ]; then
  fail "Template is incomplete — expected .claude/ and CLAUDE.md next to setup.sh (looked in: $TEMPLATE_DIR)"
  exit 1
fi

# ---------------------------------------------------------------------------
# Resolve / create target
# ---------------------------------------------------------------------------
mkdir -p "$TARGET_DIR_INPUT"
TARGET_DIR="$(cd "$TARGET_DIR_INPUT" && pwd)"

if [ "$TARGET_DIR" = "$TEMPLATE_DIR" ]; then
  fail "Target is the template itself — choose a different directory."
  exit 1
fi

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------
printf "\n"
printf "%s============================================%s\n" "${BOLD}${BLUE}" "${RESET}"
printf "%s  Riccardo-ultra-setup — Installer%s\n"          "${BOLD}"          "${RESET}"
printf "%s============================================%s\n" "${BOLD}${BLUE}" "${RESET}"
printf "%sTemplate:%s %s\n" "${DIM}" "${RESET}" "$TEMPLATE_DIR"
printf "%sTarget:  %s %s\n" "${DIM}" "${RESET}" "$TARGET_DIR"
printf "\n"

# ---------------------------------------------------------------------------
# 1) Copy .claude/  (merge-friendly)
#    - Framework content (agents/commands/skills/rules) is always refreshed.
#    - User-customized files (hooks/*.sh, settings.json) are preserved.
# ---------------------------------------------------------------------------
info "Copying .claude/ ..."
if [ -d "$TARGET_DIR/.claude" ]; then
  warn ".claude/ already exists — merging (existing hooks & settings.json preserved)"
  for sub in agents commands skills rules; do
    if [ -d "$TEMPLATE_DIR/.claude/$sub" ]; then
      mkdir -p "$TARGET_DIR/.claude/$sub"
      cp -R "$TEMPLATE_DIR/.claude/$sub/." "$TARGET_DIR/.claude/$sub/"
    fi
  done
  mkdir -p "$TARGET_DIR/.claude/hooks"
  for hook in "$TEMPLATE_DIR/.claude/hooks/"*.sh; do
    [ -e "$hook" ] || continue
    hook_name="$(basename "$hook")"
    if [ ! -f "$TARGET_DIR/.claude/hooks/$hook_name" ]; then
      cp "$hook" "$TARGET_DIR/.claude/hooks/$hook_name"
    fi
  done
  if [ ! -f "$TARGET_DIR/.claude/settings.json" ] && [ -f "$TEMPLATE_DIR/.claude/settings.json" ]; then
    cp "$TEMPLATE_DIR/.claude/settings.json" "$TARGET_DIR/.claude/settings.json"
  fi
else
  cp -R "$TEMPLATE_DIR/.claude" "$TARGET_DIR/.claude"
fi
ok ".claude/ is in place"

# ---------------------------------------------------------------------------
# 2) Copy CLAUDE.md  (never clobber a user-customized one)
# ---------------------------------------------------------------------------
if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
  warn "CLAUDE.md already exists in target — not overwriting"
else
  cp "$TEMPLATE_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
  ok "CLAUDE.md copied"
fi

# ---------------------------------------------------------------------------
# 3) Prepare .claude/logs/ + .gitkeep
# ---------------------------------------------------------------------------
info "Preparing .claude/logs/ ..."
mkdir -p \
  "$TARGET_DIR/.claude/logs" \
  "$TARGET_DIR/.claude/logs/sessions" \
  "$TARGET_DIR/.claude/logs/agents" \
  "$TARGET_DIR/.claude/logs/progress" \
  "$TARGET_DIR/.claude/logs/reviews" \
  "$TARGET_DIR/.claude/logs/prompt-trails"
: > "$TARGET_DIR/.claude/logs/.gitkeep"
ok ".claude/logs/ ready (with .gitkeep)"

# ---------------------------------------------------------------------------
# 4) Make hooks executable
# ---------------------------------------------------------------------------
if compgen -G "$TARGET_DIR/.claude/hooks/*.sh" > /dev/null; then
  chmod +x "$TARGET_DIR/.claude/hooks/"*.sh
  ok "Hook scripts are executable"
fi

# ---------------------------------------------------------------------------
# 5) .gitignore — add .claude/logs/ if a .gitignore already exists
# ---------------------------------------------------------------------------
GITIGNORE_FILE="$TARGET_DIR/.gitignore"
if [ -f "$GITIGNORE_FILE" ]; then
  if ! grep -qE "^\.claude/logs/?" "$GITIGNORE_FILE" 2>/dev/null; then
    {
      printf "\n# Claude Code logs (session-specific, not committed)\n"
      printf ".claude/logs/\n"
    } >> "$GITIGNORE_FILE"
    ok "Added .claude/logs/ to .gitignore"
  fi
fi

# ---------------------------------------------------------------------------
# Success message (verbatim as requested)
# ---------------------------------------------------------------------------
printf "\n"
printf "%s============================================%s\n" "${BOLD}${GREEN}" "${RESET}"
printf "%s  Setup completato!%s\n"                          "${BOLD}${GREEN}" "${RESET}"
printf "%s============================================%s\n" "${BOLD}${GREEN}" "${RESET}"
printf "%sSetup completato! Ricordati di aprire %sCLAUDE.md%s%s nel tuo progetto per inserire i tuoi dati personali nei campi .%s\n" \
  "${GREEN}" "${BOLD}" "${RESET}" "${GREEN}" "${RESET}"
printf "\n"
printf "%sNext:%s\n" "${DIM}" "${RESET}"
printf "  cd %s\n" "$TARGET_DIR"
printf "  claude\n"
printf "\n"
