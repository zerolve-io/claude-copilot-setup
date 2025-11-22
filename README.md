# Claude Code with GitHub Copilot Setup

Use Claude Code with your GitHub Copilot subscription instead of paying for separate Anthropic API access.

## Quick Start Options

### 🐳 DevContainer (Recommended)

**Option A: Standalone Container**

Zero setup required! Use the pre-configured Ubuntu devcontainer:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/zerolve-io/claude-copilot-setup)

Or open in VS Code locally with Dev Containers extension. See [.devcontainer/README.md](.devcontainer/README.md) for details.

**Option B: Add to Your Existing Project**

Add this feature to your existing devcontainer:

```json
{
  "features": {
    "ghcr.io/zerolve-io/devcontainer-features/claude-copilot:1": {}
  }
}
```

See [devcontainer-features](https://github.com/zerolve-io/devcontainer-features) repository for details.

### 💻 Local Installation

Install directly on your machine (macOS, Linux, or Windows with WSL).

## Prerequisites

- Active GitHub Copilot subscription
- Node.js and npm installed (or use DevContainer)
- macOS, Linux, or Windows with WSL

## Installation

### 1. Install Required Packages

```bash
# Install Copilot API proxy
npm install -g copilot-api

# Install Claude Code
npm install -g @anthropic-ai/claude-code
```

### 2. Configure Claude Code

Create the configuration file:

```bash
mkdir -p ~/.claude
```

Add the following to `~/.claude/settings.json`:

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:4141",
    "ANTHROPIC_AUTH_TOKEN": "sk-dummy",
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1"
  }
}
```

### 3. Add Shell Functions

Add the convenience functions to your shell configuration file (`~/.zshrc` for zsh or `~/.bashrc` for bash):

```bash
# Claude Code with GitHub Copilot
claudecopilot() {
    # Check if copilot-api is already running
    if pgrep -f "copilot-api start" > /dev/null; then
        echo "✓ Copilot API proxy already running"
        
        # Test if it's responding
        if curl -s http://localhost:4141/v1/models > /dev/null 2>&1; then
            echo "✓ Proxy is authenticated and ready"
        else
            echo "⚠ Proxy is running but not ready yet, waiting..."
            sleep 2
        fi
    else
        echo "Starting Copilot API proxy..."
        copilot-api start > /tmp/copilot-api.log 2>&1 &
        PROXY_PID=$!
        
        echo "Waiting for proxy to start..."
        
        # Wait up to 30 seconds for proxy to be ready
        for i in {1..30}; do
            if curl -s http://localhost:4141/v1/models > /dev/null 2>&1; then
                echo "✓ Proxy is ready"
                break
            fi
            
            # Check if authentication is needed
            if grep -q "Please enter the code" /tmp/copilot-api.log 2>/dev/null; then
                echo ""
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo "⚠ GitHub authentication required!"
                tail -3 /tmp/copilot-api.log | grep -E "code|https"
                echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
                echo ""
                echo "Waiting for authentication..."
            fi
            
            sleep 1
        done
        
        # Final check
        if ! curl -s http://localhost:4141/v1/models > /dev/null 2>&1; then
            echo "✗ Failed to start proxy. Check /tmp/copilot-api.log for details"
            return 1
        fi
    fi
    
    echo ""
    echo "Starting Claude Code..."
    echo "(Copilot API proxy will keep running in background)"
    echo ""
    
    # Run Claude Code
    claude
}

# Alias to stop the copilot-api proxy
alias stopcopilot='pkill -f "copilot-api start" && echo "✓ Stopped Copilot API proxy"'
```

### 4. Reload Shell Configuration

```bash
# For zsh
source ~/.zshrc

# For bash
source ~/.bashrc
```

## Usage

### Start Claude Code with Copilot

```bash
claudecopilot
```

**First time only:** You'll need to authenticate with GitHub:
1. The command will display a device code
2. Go to https://github.com/login/device
3. Enter the code shown
4. Once authenticated, Claude Code will start automatically

**Subsequent uses:** Just run `claudecopilot` - the proxy stays running in the background.

### Stop the Copilot API Proxy

When you're done for the day:

```bash
stopcopilot
```

## How It Works

1. **copilot-api** - Provides a proxy that translates Anthropic API calls to GitHub Copilot API calls
2. **Claude Code** - Configured to use the local proxy instead of Anthropic's API
3. **Shell function** - Automates starting the proxy and Claude Code together

## Available Models

When using GitHub Copilot, you have access to:
- `claude-sonnet-4.5` - Main Claude model
- `claude-haiku-4.5` - Fast Claude model
- `gpt-5-mini` - Fast GPT model (used as Haiku alternative)
- `gpt-4.1`, `gpt-5`, `gpt-4o` - Various GPT models
- `gemini-2.5-pro`, `gemini-3-pro-preview` - Gemini models

## Troubleshooting

### Proxy not responding
Check the logs:
```bash
cat /tmp/copilot-api.log
```

### Authentication issues
Stop the proxy and restart:
```bash
stopcopilot
claudecopilot
```

### Port already in use
Check what's using port 4141:
```bash
lsof -i :4141
```

Kill the process if needed:
```bash
pkill -f "copilot-api"
```

## Credits

Based on the article: [Using Claude Code with GitHub Copilot Subscription](https://dev.to/allentcm/using-claude-code-with-github-copilot-subscription-2obj)

## License

MIT
