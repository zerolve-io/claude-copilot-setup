#!/bin/bash

# Claude Code Quick Start Generator
# Quickly bootstrap a new project with Claude Code + GitHub Copilot

set -e

echo "════════════════════════════════════════════════════════════════"
echo "  Claude Code - Quick Start Generator"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Get project name
read -p "Project name: " project_name
if [ -z "$project_name" ]; then
    echo "❌ Project name is required"
    exit 1
fi

# Check if directory exists
if [ -d "$project_name" ]; then
    echo "❌ Directory '$project_name' already exists"
    exit 1
fi

echo ""
echo "Select project type:"
echo ""
echo "  1) Python          - Python 3.11 with pip"
echo "  2) Node.js         - Node.js LTS with npm"
echo "  3) Go              - Go latest"
echo "  4) Rust            - Rust latest"
echo "  5) Full Stack      - Node.js + Python + Docker"
echo "  6) Data Science    - Python + Jupyter + ML libraries"
echo "  7) Custom          - Specify your own base image"
echo ""
read -p "Choice (1-7): " -n 1 -r choice
echo ""
echo ""

case $choice in
    1)
        BASE_IMAGE="mcr.microsoft.com/devcontainers/python:3.11"
        PROJECT_TYPE="Python"
        POST_CREATE="pip install --upgrade pip"
        PORTS="[8000]"
        SUGGESTED_MODEL="claude-sonnet-4.5"
        ;;
    2)
        BASE_IMAGE="mcr.microsoft.com/devcontainers/javascript-node:lts"
        PROJECT_TYPE="Node.js"
        POST_CREATE="npm install"
        PORTS="[3000]"
        SUGGESTED_MODEL="gpt-5-mini"
        ;;
    3)
        BASE_IMAGE="mcr.microsoft.com/devcontainers/go:latest"
        PROJECT_TYPE="Go"
        POST_CREATE="go version"
        PORTS="[8080]"
        SUGGESTED_MODEL="claude-sonnet-4.5"
        ;;
    4)
        BASE_IMAGE="mcr.microsoft.com/devcontainers/rust:latest"
        PROJECT_TYPE="Rust"
        POST_CREATE="rustc --version"
        PORTS="[8080]"
        SUGGESTED_MODEL="claude-sonnet-4.5"
        ;;
    5)
        BASE_IMAGE="mcr.microsoft.com/devcontainers/python:3.11"
        PROJECT_TYPE="Full Stack"
        POST_CREATE="pip install --upgrade pip && npm install -g npm@latest"
        PORTS="[3000, 8000]"
        SUGGESTED_MODEL="claude-sonnet-4.5"
        EXTRA_FEATURES='"ghcr.io/devcontainers/features/node:1": {"version": "lts"},'
        ;;
    6)
        BASE_IMAGE="mcr.microsoft.com/devcontainers/python:3.11"
        PROJECT_TYPE="Data Science"
        POST_CREATE="pip install jupyter pandas numpy scikit-learn matplotlib seaborn"
        PORTS="[8888]"
        SUGGESTED_MODEL="claude-sonnet-4.5"
        ;;
    7)
        echo "Enter base image (e.g., mcr.microsoft.com/devcontainers/python:3.11):"
        read -p "Base image: " BASE_IMAGE
        PROJECT_TYPE="Custom"
        POST_CREATE="echo 'Container ready'"
        PORTS="[]"
        SUGGESTED_MODEL="claude-sonnet-4.5"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo "Select Claude model preset:"
echo ""
echo "  1) Best Quality     - claude-sonnet-4.5 (slower, best reasoning)"
echo "  2) Balanced         - claude-sonnet-4.5 + gpt-5-mini"
echo "  3) Fast             - gpt-5-mini (fastest, good for simple tasks)"
echo "  4) Custom           - Specify your own models"
echo ""
read -p "Choice (1-4) [2]: " -n 1 -r model_choice
model_choice=${model_choice:-2}
echo ""
echo ""

case $model_choice in
    1)
        PRIMARY_MODEL="claude-sonnet-4.5"
        HAIKU_MODEL="claude-haiku-4.5"
        ;;
    2)
        PRIMARY_MODEL="claude-sonnet-4.5"
        HAIKU_MODEL="gpt-5-mini"
        ;;
    3)
        PRIMARY_MODEL="gpt-5-mini"
        HAIKU_MODEL="gpt-5-mini"
        ;;
    4)
        echo "Available models:"
        echo "  - claude-sonnet-4.5"
        echo "  - claude-haiku-4.5"
        echo "  - gpt-5-mini"
        echo "  - gpt-4o"
        echo "  - gemini-2.5-pro"
        echo ""
        read -p "Primary model: " PRIMARY_MODEL
        read -p "Fast model: " HAIKU_MODEL
        ;;
    *)
        PRIMARY_MODEL="claude-sonnet-4.5"
        HAIKU_MODEL="gpt-5-mini"
        ;;
esac

echo "Initialize git repository?"
read -p "Git init? (Y/n): " -n 1 -r git_init
git_init=${git_init:-Y}
echo ""
echo ""

# Create project
echo "Creating project '$project_name'..."
mkdir -p "$project_name/.devcontainer"
cd "$project_name"

# Create devcontainer.json
cat > .devcontainer/devcontainer.json << EOF
{
  "name": "${project_name}",
  "image": "${BASE_IMAGE}",
  
  "features": {
    ${EXTRA_FEATURES}
    "ghcr.io/zerolve-io/devcontainer-features/claude-copilot:1": {
      "model": "${PRIMARY_MODEL}",
      "haikuModel": "${HAIKU_MODEL}"
    }
  },
  
  "forwardPorts": ${PORTS},
  
  "postCreateCommand": "${POST_CREATE}",
  
  "customizations": {
    "vscode": {
      "extensions": [
        "GitHub.copilot",
        "GitHub.copilot-chat"
      ]
    }
  }
}
EOF

# Create README
cat > README.md << EOF
# ${project_name}

${PROJECT_TYPE} project with Claude Code + GitHub Copilot integration.

## Quick Start

### Using VS Code + Docker Desktop

1. Open this folder in VS Code
2. Click "Reopen in Container" when prompted
3. Wait for container to build
4. Run \`claudecopilot\` in terminal
5. Authenticate with GitHub (first time only)
6. Start coding with Claude!

### Using GitHub Codespaces

1. Push this repo to GitHub
2. Click "Code" → "Codespaces" → "Create codespace"
3. Wait for container to build
4. Run \`claudecopilot\` in terminal
5. Start coding with Claude!

## Configuration

- **Model**: ${PRIMARY_MODEL}
- **Fast Model**: ${HAIKU_MODEL}
- **Type**: ${PROJECT_TYPE}

To change models, edit \`.devcontainer/devcontainer.json\`.

## Commands

- \`claudecopilot\` - Start Claude Code with GitHub Copilot
- \`stopcopilot\` - Stop the Copilot API proxy

## Documentation

- [Main Repository](https://github.com/zerolve-io/claude-copilot-setup)
- [DevContainer Features](https://github.com/zerolve-io/devcontainer-features)
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
__pycache__/
*.pyc
.venv/
venv/
env/

# IDE
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Build outputs
dist/
build/
*.egg-info/

# Environment
.env
.env.local
EOF

# Initialize git if requested
if [[ $git_init =~ ^[Yy]$ ]]; then
    git init
    git add .
    git commit -m "Initial commit: ${PROJECT_TYPE} project with Claude Code"
    echo "✓ Git repository initialized"
fi

echo ""
echo "✓ Project '$project_name' created successfully!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Project Details:"
echo "  Name:          $project_name"
echo "  Type:          $PROJECT_TYPE"
echo "  Model:         $PRIMARY_MODEL"
echo "  Fast Model:    $HAIKU_MODEL"
echo "  Location:      $(pwd)"
echo ""
echo "Next Steps:"
echo ""
echo "  1. Open in VS Code:"
echo "     cd $project_name && code ."
echo ""
echo "  2. Click 'Reopen in Container' when prompted"
echo ""
echo "  3. Once container is ready, run:"
echo "     claudecopilot"
echo ""
echo "  4. Authenticate with GitHub (first time only)"
echo ""
echo "  5. Start coding with Claude!"
echo ""
echo "Alternative - Push to GitHub and use Codespaces:"
echo "  gh repo create $project_name --private --source=."
echo "  git push -u origin main"
echo "  # Then open in Codespaces from GitHub"
echo ""
echo "Documentation: https://github.com/zerolve-io/claude-copilot-setup"
echo ""
