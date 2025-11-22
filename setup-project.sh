#!/bin/bash

# Claude Project Setup - Configure Claude Code for your project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLES_DIR="$SCRIPT_DIR/examples/project-settings"

echo "════════════════════════════════════════════════════════════════"
echo "  Claude Code - Project Setup"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Check if we're in a project directory
if [ ! -d ".git" ] && [ ! -f "package.json" ] && [ ! -f "setup.py" ] && [ ! -f "go.mod" ]; then
    echo "⚠ Warning: This doesn't look like a project directory."
    echo "  (No .git, package.json, setup.py, or go.mod found)"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Check if .claude already exists
if [ -f ".claude/settings.json" ]; then
    echo "⚠ .claude/settings.json already exists"
    echo ""
    cat .claude/settings.json
    echo ""
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo "Select a project type:"
echo ""
echo "  1) Python ML/AI - Heavy computation, deep reasoning"
echo "  2) Frontend - Fast iterations, simple tasks"
echo "  3) Backend API - Complex business logic"
echo "  4) Documentation - Quality writing, balanced speed"
echo "  5) Legacy Refactor - Complex analysis, full features"
echo "  6) Large Codebase - Long context, multi-file analysis"
echo "  7) Custom - Specify your own settings"
echo "  8) Default - Use global settings"
echo ""
read -p "Choice (1-8): " -n 1 -r choice
echo ""
echo ""

case $choice in
    1)
        TEMPLATE="python-ml.json"
        DESC="Python ML/AI"
        ;;
    2)
        TEMPLATE="frontend.json"
        DESC="Frontend"
        ;;
    3)
        TEMPLATE="backend-api.json"
        DESC="Backend API"
        ;;
    4)
        TEMPLATE="documentation.json"
        DESC="Documentation"
        ;;
    5)
        TEMPLATE="legacy-refactor.json"
        DESC="Legacy Refactor"
        ;;
    6)
        TEMPLATE="large-codebase.json"
        DESC="Large Codebase"
        ;;
    7)
        echo "Available models:"
        echo "  - claude-sonnet-4.5 (best quality, slower)"
        echo "  - claude-haiku-4.5 (fast Claude)"
        echo "  - gpt-5-mini (fastest, cost-effective)"
        echo "  - gpt-4o (balanced)"
        echo "  - gemini-2.5-pro (long context)"
        echo ""
        read -p "Primary model: " model
        read -p "Fast model: " haiku_model
        
        mkdir -p .claude
        cat > .claude/settings.json << EOF
{
  "env": {
    "ANTHROPIC_MODEL": "${model}",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "${haiku_model}",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1"
  }
}
EOF
        echo "✓ Created custom .claude/settings.json"
        cat .claude/settings.json
        exit 0
        ;;
    8)
        echo "Using global settings from ~/.claude/settings.json"
        echo "No project-specific configuration created."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

# Copy template
mkdir -p .claude
cp "$EXAMPLES_DIR/$TEMPLATE" .claude/settings.json

echo "✓ Created .claude/settings.json for $DESC project"
echo ""
echo "Configuration:"
cat .claude/settings.json
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Review .claude/settings.json and adjust if needed"
echo "  2. Decide if you want to commit this file:"
echo "     - YES: Team uses same settings (recommended)"
echo "     - NO: Add .claude/ to .gitignore for personal settings"
echo "  3. Run 'claudecopilot' to start using Claude Code"
echo ""
echo "To change settings later, run this script again or edit:"
echo "  .claude/settings.json"
echo ""
