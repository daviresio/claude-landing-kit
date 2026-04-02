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
echo "  /landing         — cria e constrói landing pages"
echo "  /landing-review  — review completo com subagentes paralelos"
echo "  /frontend-design — referência de design (usado internamente)"
echo ""
echo "  Como usar:"
echo ""
echo "    mkdir meu-projeto && cd meu-projeto"
echo "    claude"
echo "    /landing crie uma landing page para [sua ideia]"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
