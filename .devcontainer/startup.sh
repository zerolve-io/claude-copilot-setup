#!/bin/bash

# Startup script for devcontainer
echo "════════════════════════════════════════════════════════════════"
echo "  Claude Code with GitHub Copilot - DevContainer"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Function definition
CLAUDE_FUNCTIONS='
# Claude Code with GitHub Copilot
claudecopilot() {
    # Check if copilot-api is already running
    if pgrep -f "copilot-api start" > /dev/null; then
        echo "✓ Copilot API proxy already running"
        
        # Test if it'\''s responding
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
alias stopcopilot='\''pkill -f "copilot-api start" && echo "✓ Stopped Copilot API proxy"'\''
'

# Add to bashrc if not already present
if ! grep -q "# Claude Code with GitHub Copilot" ~/.bashrc 2>/dev/null; then
    echo "$CLAUDE_FUNCTIONS" >> ~/.bashrc
fi

# Also add to bash_profile for immediate loading
if ! grep -q "# Claude Code with GitHub Copilot" ~/.bash_profile 2>/dev/null; then
    echo "$CLAUDE_FUNCTIONS" >> ~/.bash_profile
fi

# Source it for the current session
eval "$CLAUDE_FUNCTIONS"

echo "✓ DevContainer ready!"
echo ""
echo "Commands available (loaded and ready to use):"
echo "  claudecopilot - Start Claude Code with GitHub Copilot"
echo "  stopcopilot   - Stop the Copilot API proxy"
echo ""
echo "════════════════════════════════════════════════════════════════"
