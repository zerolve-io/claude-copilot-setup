#!/bin/bash

# Workspace Setup Script
# Helps configure devcontainer for different workspace patterns

set -e

echo "════════════════════════════════════════════════════════════════"
echo "  Claude Code - Workspace Setup"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "This script helps you configure your devcontainer to work with"
echo "your local project structure."
echo ""

# Check if .devcontainer exists
if [ ! -d ".devcontainer" ]; then
    echo "Creating .devcontainer directory..."
    mkdir -p .devcontainer
fi

if [ -f ".devcontainer/devcontainer.json" ]; then
    echo "⚠ .devcontainer/devcontainer.json already exists"
    echo ""
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo "Select workspace pattern:"
echo ""
echo "  1) Single Project - Focus on one project"
echo "  2) Multi-Project - Work with multiple related projects"
echo "  3) Full Workspace - Mount entire projects directory"
echo "  4) Team Setup - Standardized team configuration"
echo "  5) Custom - Manual configuration"
echo ""
read -p "Choice (1-5): " -n 1 -r choice
echo ""
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLES_DIR="$SCRIPT_DIR/examples/workspace-setups"

case $choice in
    1)
        TEMPLATE="single-project.json"
        DESC="Single Project"
        echo "This will configure the devcontainer to work with this project."
        ;;
    2)
        TEMPLATE="multi-project.json"
        DESC="Multi-Project"
        echo "This will configure the devcontainer to mount multiple projects."
        echo ""
        read -p "Enter path to projects directory [~/projects]: " projects_dir
        projects_dir=${projects_dir:-~/projects}
        echo ""
        echo "This setup expects projects at:"
        echo "  $projects_dir/frontend"
        echo "  $projects_dir/backend"
        echo "  $projects_dir/shared"
        echo ""
        read -p "Continue? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
        ;;
    3)
        TEMPLATE="full-workspace.json"
        DESC="Full Workspace"
        echo "This will mount your entire projects directory with all tools."
        echo ""
        read -p "Enter path to projects directory [~/projects]: " projects_dir
        projects_dir=${projects_dir:-~/projects}
        ;;
    4)
        TEMPLATE="team-setup.json"
        DESC="Team Setup"
        echo "This will create a standardized team development environment."
        ;;
    5)
        echo "Manual configuration selected."
        echo ""
        echo "Available templates:"
        echo "  - single-project.json"
        echo "  - multi-project.json"
        echo "  - full-workspace.json"
        echo "  - team-setup.json"
        echo ""
        echo "Copy a template from examples/workspace-setups/ to"
        echo ".devcontainer/devcontainer.json and customize it."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

# Copy template
echo "Setting up $DESC workspace..."
cp "$EXAMPLES_DIR/$TEMPLATE" .devcontainer/devcontainer.json

echo ""
echo "✓ Created .devcontainer/devcontainer.json"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo ""
echo "  1. Review .devcontainer/devcontainer.json"
echo "  2. Adjust mount paths if needed"
echo "  3. Open in VS Code and select 'Reopen in Container'"
echo "     OR open in GitHub Codespaces"
echo "  4. Wait for container to build"
echo "  5. Run 'claudecopilot' to start coding!"
echo ""
echo "Configuration file: .devcontainer/devcontainer.json"
echo "Documentation: examples/workspace-setups/README.md"
echo ""
