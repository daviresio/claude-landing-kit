#!/bin/bash
# claude-landing-kit setup
# Installs Claude Code skills for landing page development
# Usage: bash setup.sh

set -e

CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
KIT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Claude Landing Kit — Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Claude Code is installed
if ! command -v claude &> /dev/null; then
  echo "❌ Claude Code not found. Install it first:"
  echo "   npm install -g @anthropic-ai/claude-code"
  echo "   or visit: https://claude.ai/code"
  exit 1
fi

echo "✓ Claude Code found: $(claude --version 2>/dev/null || echo 'installed')"

# Create commands directory if it doesn't exist
mkdir -p "$COMMANDS_DIR"

# Install commands
echo ""
echo "Installing skills..."

for cmd_file in "$KIT_DIR/commands/"*.md; do
  cmd_name=$(basename "$cmd_file" .md)
  dest="$COMMANDS_DIR/$cmd_name.md"

  if [ -f "$dest" ]; then
    echo "  ↻ /$(basename "$cmd_name") — updated"
  else
    echo "  + /$(basename "$cmd_name") — installed"
  fi

  cp "$cmd_file" "$dest"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Done! Skills installed:"
echo ""
echo "  /landing          — cria e constrói landing pages"
echo "                      (design → tokens → componentes"
echo "                       → seções → review automático)"
echo "  /landing-review   — review completo com subagentes paralelos"
echo "  /landing-continue — audita o que existe e continua de onde parou"
echo "  /frontend-design  — referência de design (usado internamente)"
echo ""
echo "  Quick start:"
echo "  1. Open a terminal in your project folder"
echo "  2. Run: claude"
echo "  3. Type: /landing create a landing page for [your idea]"
echo ""
echo "  For new projects, copy project-template/CLAUDE.md"
echo "  to your project root before starting."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
