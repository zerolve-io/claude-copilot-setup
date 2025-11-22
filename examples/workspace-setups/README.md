# Workspace Management

Configure the devcontainer to work with multiple projects and custom workspace layouts.

## Overview

The devcontainer can be configured to:
- Mount your existing projects from the host machine
- Work with multiple projects simultaneously
- Preserve workspace state between rebuilds
- Use custom directory structures

## Common Workspace Patterns

### Pattern 1: Single Project Focus

Mount one specific project into the container.

**Use case:** Working on a single large project

```json
{
  "name": "My Project with Claude",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  
  "workspaceMount": "source=${localWorkspaceFolder},target=/workspace/my-project,type=bind",
  "workspaceFolder": "/workspace/my-project",
  
  "features": {
    "ghcr.io/zerolve-io/devcontainer-features/claude-copilot:1": {}
  }
}
```

### Pattern 2: Multi-Project Workspace

Mount multiple projects for working across repositories.

**Use case:** Microservices, monorepos, or related projects

```json
{
  "name": "Multi-Project Workspace",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  
  "mounts": [
    "source=${localEnv:HOME}/projects/frontend,target=/workspace/frontend,type=bind",
    "source=${localEnv:HOME}/projects/backend,target=/workspace/backend,type=bind",
    "source=${localEnv:HOME}/projects/shared,target=/workspace/shared,type=bind"
  ],
  
  "workspaceFolder": "/workspace",
  
  "features": {
    "ghcr.io/zerolve-io/devcontainer-features/claude-copilot:1": {}
  }
}
```

### Pattern 3: Dynamic Projects Directory

Mount your entire projects folder.

**Use case:** Flexibility to work on any project

```json
{
  "name": "All Projects Workspace",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  
  "mounts": [
    "source=${localEnv:HOME}/projects,target=/workspace/projects,type=bind",
    "source=${localEnv:HOME}/workspaces,target=/workspace/workspaces,type=bind"
  ],
  
  "workspaceFolder": "/workspace",
  
  "features": {
    "ghcr.io/zerolve-io/devcontainer-features/claude-copilot:1": {}
  }
}
```

### Pattern 4: Persistent Development Environment

Create volumes for data that persists across rebuilds.

**Use case:** Preserve CLI history, cache, installed tools

```json
{
  "name": "Persistent Dev Environment",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  
  "mounts": [
    "source=${localEnv:HOME}/projects,target=/workspace/projects,type=bind",
    "source=claude-history,target=/home/vscode/.local/state,type=volume",
    "source=claude-cache,target=/home/vscode/.cache,type=volume",
    "source=copilot-auth,target=/home/vscode/.config/github-copilot,type=volume"
  ],
  
  "workspaceFolder": "/workspace/projects",
  
  "features": {
    "ghcr.io/zerolve-io/devcontainer-features/claude-copilot:1": {}
  }
}
```

## VS Code Multi-Root Workspaces

For ultimate flexibility, use VS Code's multi-root workspace feature.

### Example: `.code-workspace` file

```json
{
  "folders": [
    {
      "name": "Frontend",
      "path": "/workspace/frontend"
    },
    {
      "name": "Backend",
      "path": "/workspace/backend"
    },
    {
      "name": "Shared Libraries",
      "path": "/workspace/shared"
    }
  ],
  "settings": {
    "terminal.integrated.defaultProfile.linux": "bash"
  }
}
```

Save as `my-workspace.code-workspace` and open it in VS Code.

## Environment-Specific Configurations

### Development Machine

```json
{
  "mounts": [
    "source=${localEnv:HOME}/dev,target=/workspace,type=bind"
  ]
}
```

### Corporate Network

```json
{
  "mounts": [
    "source=${localEnv:HOME}/company-projects,target=/workspace,type=bind"
  ],
  "remoteEnv": {
    "HTTP_PROXY": "${localEnv:HTTP_PROXY}",
    "HTTPS_PROXY": "${localEnv:HTTPS_PROXY}"
  }
}
```

### Shared Team Setup

```json
{
  "mounts": [
    "source=/mnt/shared-projects,target=/workspace,type=bind"
  ]
}
```

## Organizing Project Settings

### Workspace Structure

```
/workspace/
├── frontend/
│   └── .claude/
│       └── settings.json          # Fast iterations (gpt-5-mini)
├── backend/
│   └── .claude/
│       └── settings.json          # Complex logic (claude-sonnet-4.5)
├── ml-service/
│   └── .claude/
│       └── settings.json          # Heavy reasoning (claude-sonnet-4.5 + haiku)
└── docs/
    └── .claude/
        └── settings.json          # Quality writing (claude-sonnet-4.5)
```

Each project gets optimized settings automatically when you `cd` into it!

## Quick Setup Script

Create a workspace setup script:

```bash
#!/bin/bash
# setup-workspace.sh

WORKSPACE_DIR="${1:-$HOME/workspace}"

mkdir -p "$WORKSPACE_DIR"/{frontend,backend,shared,docs}

echo "Setting up Claude Code workspace at $WORKSPACE_DIR"

# Setup frontend project settings
mkdir -p "$WORKSPACE_DIR/frontend/.claude"
cat > "$WORKSPACE_DIR/frontend/.claude/settings.json" << 'EOF'
{
  "env": {
    "ANTHROPIC_MODEL": "gpt-5-mini",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini"
  }
}
EOF

# Setup backend project settings
mkdir -p "$WORKSPACE_DIR/backend/.claude"
cat > "$WORKSPACE_DIR/backend/.claude/settings.json" << 'EOF'
{
  "env": {
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-4o"
  }
}
EOF

echo "✓ Workspace ready at $WORKSPACE_DIR"
```

## Using with GitHub Codespaces

### Codespaces automatically clones the repo

No additional mounts needed - just work with the cloned repository.

### Accessing other repositories

Use git to clone additional repos:

```bash
cd /workspace
git clone https://github.com/your-org/other-project.git
cd other-project
./setup-project.sh  # Configure Claude settings
```

## Tips & Best Practices

### ✅ DO

- **Mount projects read-write** for full development workflow
- **Use volumes for persistent data** (history, cache, auth)
- **Organize by project type** with appropriate settings
- **Document workspace structure** in README
- **Commit `.claude/settings.json`** for team consistency

### ❌ DON'T

- **Mount sensitive directories** like `/etc` or `/var`
- **Mix personal and work projects** in the same container
- **Use absolute paths** - use `${localEnv:HOME}` instead
- **Mount the entire filesystem** - be selective
- **Forget to backup** work outside containers

## Troubleshooting

### Mount path doesn't exist

```bash
# Create directory on host first
mkdir -p ~/projects
```

### Permission issues

```bash
# Check container user
whoami  # Should be 'vscode' or similar

# Fix ownership if needed (on host)
sudo chown -R $(whoami) ~/projects
```

### Changes not persisting

- Check if using `type=bind` (persists) vs `type=volume` (container-local)
- Verify mount source exists
- Rebuild container if needed

### Performance on macOS/Windows

- Use named volumes instead of bind mounts for better performance
- Consider using Docker Desktop's file sharing settings

## Examples

See the `examples/workspace-setups/` directory for complete devcontainer configurations:

- `single-project.json` - One project focus
- `multi-project.json` - Multiple related projects  
- `full-workspace.json` - Complete development environment
- `team-setup.json` - Shared team configuration

## Next Steps

1. Choose a workspace pattern that fits your needs
2. Copy example configuration to `.devcontainer/devcontainer.json`
3. Adjust mount paths to match your local setup
4. Rebuild devcontainer
5. Run `claudecopilot` and start coding!
