#!/bin/bash

set -e

echo "════════════════════════════════════════════════════════════════"
echo "  Claude Code with GitHub Copilot - Automated Setup"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo "✗ Node.js is not installed. Please install it first:"
    echo "  https://nodejs.org/"
    exit 1
fi

echo "✓ Node.js found: $(node --version)"
echo ""

# Install packages
echo "Installing packages..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "→ Installing copilot-api..."
npm install -g copilot-api

echo ""
echo "→ Installing @anthropic-ai/claude-code..."
npm install -g @anthropic-ai/claude-code

echo ""
echo "✓ Packages installed successfully"
echo ""

# Create Claude config directory
echo "Setting up Claude Code configuration..."
mkdir -p ~/.claude

# Create settings.json
cat > ~/.claude/settings.json << 'EOF'
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
EOF

echo "✓ Created ~/.claude/settings.json"
echo ""

# Detect shell
SHELL_RC=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    echo "⚠ Could not detect shell type. Please manually add functions to your shell config."
    echo "  See README.md for the functions to add."
    exit 0
fi

echo "Adding shell functions to $SHELL_RC..."
echo ""

# Check if function already exists
if grep -q "# Claude Code with GitHub Copilot" "$SHELL_RC" 2>/dev/null; then
    echo "⚠ Functions already exist in $SHELL_RC"
    read -p "  Do you want to update them? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping shell function installation."
        echo ""
        echo "════════════════════════════════════════════════════════════════"
        echo "Setup complete! Run 'claudecopilot' to start."
        echo "════════════════════════════════════════════════════════════════"
        exit 0
    fi
    
    # Remove old functions
    sed -i.bak '/# Claude Code with GitHub Copilot/,/^alias stopcopilot=/d' "$SHELL_RC"
fi

# Add functions
cat >> "$SHELL_RC" << 'EOF'

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
EOF

echo "✓ Added functions to $SHELL_RC"
echo ""

echo "════════════════════════════════════════════════════════════════"
echo "  Setup Complete!"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Reload your shell:"
echo "     source $SHELL_RC"
echo ""
echo "  2. Start Claude Code:"
echo "     claudecopilot"
echo ""
echo "  3. First time only - authenticate with GitHub when prompted"
echo ""
echo "  4. When done for the day:"
echo "     stopcopilot"
echo ""
echo "════════════════════════════════════════════════════════════════"
