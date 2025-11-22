# DevContainer for Claude Code with GitHub Copilot

This devcontainer provides a pre-configured Ubuntu environment with Claude Code and GitHub Copilot integration.

## What's Included

- **Base**: Ubuntu 24.04
- **Node.js**: LTS version
- **GitHub CLI**: Latest version
- **Pre-installed**: copilot-api, @anthropic-ai/claude-code
- **Shell functions**: `claudecopilot` and `stopcopilot` commands

## Quick Start

### Option 1: Open in VS Code

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Install [VS Code Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Clone this repo:
   ```bash
   git clone https://github.com/zerolve-io/claude-copilot-setup.git
   ```
4. Open in VS Code and click "Reopen in Container" when prompted

### Option 2: GitHub Codespaces

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/zerolve-io/claude-copilot-setup)

Click the badge above to open directly in GitHub Codespaces.

## Usage Inside Container

Once the container is running:

```bash
# Start Claude Code with Copilot
claudecopilot

# Stop the Copilot API proxy when done
stopcopilot
```

**First time**: You'll need to authenticate with GitHub by visiting the URL shown and entering the device code.

## Configuration

The devcontainer automatically:
- Installs required npm packages globally
- Creates `~/.claude/settings.json` with proper configuration
- Adds shell functions to `~/.bashrc`
- Forwards port 4141 for the Copilot API proxy
- Mounts your GitHub Copilot credentials (if available)

## Environment Variables

The following environment variables are pre-configured:

- `ANTHROPIC_BASE_URL=http://localhost:4141`
- `ANTHROPIC_AUTH_TOKEN=sk-dummy`
- `ANTHROPIC_MODEL=claude-sonnet-4.5`
- `ANTHROPIC_DEFAULT_HAIKU_MODEL=gpt-5-mini`
- `DISABLE_NON_ESSENTIAL_MODEL_CALLS=1`
- `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`

## Customization

### Changing the Base Image

Edit `.devcontainer/devcontainer.json`:

```json
"image": "mcr.microsoft.com/devcontainers/base:ubuntu-22.04"
```

### Adding More Features

Add to the `features` section:

```json
"features": {
  "ghcr.io/devcontainers/features/git:1": {},
  "ghcr.io/devcontainers/features/docker-in-docker:2": {}
}
```

## Troubleshooting

### Copilot authentication not persisting

The devcontainer tries to mount your local GitHub Copilot credentials. If authentication keeps asking, try:

1. Authenticate on your host machine first
2. Rebuild the container: `Cmd/Ctrl + Shift + P` → "Dev Containers: Rebuild Container"

### Port 4141 already in use

Check if another instance is running:
```bash
lsof -i :4141
pkill -f "copilot-api"
```

### Claude Code not found

The packages should install automatically. If not, run:
```bash
npm install -g copilot-api @anthropic-ai/claude-code
```

## Benefits of DevContainer Approach

✅ **Consistent Environment** - Same setup across all machines  
✅ **No Local Installation** - Everything runs in container  
✅ **Easy Cleanup** - Delete container when done  
✅ **Team Ready** - Share exact configuration via Git  
✅ **Cloud Compatible** - Works with GitHub Codespaces  

## Requirements

- Docker Desktop (for local development)
- VS Code with Dev Containers extension (for local development)
- OR GitHub account (for Codespaces)
- Active GitHub Copilot subscription
