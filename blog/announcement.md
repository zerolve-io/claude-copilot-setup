---
title: "Use Claude Code with Your GitHub Copilot Subscription (For Free!)"
description: "Stop paying for Claude Pro - use your existing GitHub Copilot subscription to access Claude Sonnet 4.5, GPT-5, and more AI models in one unified development environment"
author: "Zerolve"
date: "2024-11-22"
tags: ["claude", "github-copilot", "ai", "devcontainers", "development"]
---

# Use Claude Code with Your GitHub Copilot Subscription (For Free!)

If you're a developer with a GitHub Copilot subscription, you're already paying for access to some of the world's best AI models. But did you know you can use that same subscription to run **Claude Sonnet 4.5** in your terminal, without paying extra for Claude Pro?

Here's how to get started in under 5 minutes.

## The Problem

As developers, we're drowning in AI subscriptions:
- 💰 GitHub Copilot: $10-20/month (you probably already have this)
- 💰 Claude Pro: $20/month (for Claude Code access)
- 💰 ChatGPT Plus: $20/month
- 💰 Cursor: $20/month

**That's $70+/month** just for AI coding tools!

## The Solution

Your GitHub Copilot subscription already includes access to:
- ✅ Claude Sonnet 4.5
- ✅ Claude Haiku 4.5
- ✅ GPT-4.1, GPT-5, GPT-5 Mini
- ✅ Gemini 2.5 Pro
- ✅ And more models being added regularly

You just need the right setup to use them.

## Quick Start: Create a New Project

The fastest way to start a new project with Claude Code:

```bash
curl -fsSL https://raw.githubusercontent.com/zerolve-io/claude-copilot-setup/main/create-project.sh | bash
```

**That's it!** The script will:
1. Ask for your project name
2. Let you choose project type (Python, Node.js, Go, etc.)
3. Configure Claude Code with GitHub Copilot
4. Create everything you need (devcontainer, README, .gitignore)

Then just:
```bash
cd your-project
code .
# Click "Reopen in Container"
claudecopilot
```

## What You Get

### 1. Access to Multiple AI Models

Your GitHub Copilot subscription gives you access to:

| Model | Best For |
|-------|----------|
| claude-sonnet-4.5 | Complex reasoning, architecture decisions |
| claude-haiku-4.5 | Fast iterations, simple tasks |
| gpt-5-mini | Fastest responses, repetitive tasks |
| gpt-4o | Balanced performance |
| gemini-2.5-pro | Long context windows, large codebases |

### 2. Project-Specific Configuration

Different projects need different models. Our setup includes templates for:

- **Python ML/AI** → Claude Sonnet (deep reasoning)
- **Frontend** → GPT-5 Mini (fast iterations)
- **Backend APIs** → Claude Sonnet + GPT-4o
- **Documentation** → Claude Sonnet (quality writing)
- **Legacy Refactoring** → Full Claude features
- **Large Codebases** → Gemini 2.5 Pro (long context)

### 3. Multiple Deployment Options

Choose what works for you:

**GitHub Codespaces** (Zero Setup)
```bash
# Just click this badge on any repo with the setup
Open in Codespaces
```

**VS Code + Docker** (Local Development)
```bash
# Add one feature to your devcontainer.json
{
  "features": {
    "ghcr.io/zerolve-io/devcontainer-features/claude-copilot:1": {}
  }
}
```

**Local Installation** (No Containers)
```bash
curl -fsSL https://raw.githubusercontent.com/zerolve-io/claude-copilot-setup/main/install.sh | bash
source ~/.bashrc
claudecopilot
```

## Real-World Example: Building a FastAPI App

Here's how I used this setup to build a production API in 30 minutes:

```bash
# 1. Create project
./create-project.sh
# Enter: my-api
# Choose: Python
# Choose: Balanced (Sonnet + GPT-5 Mini)

# 2. Open in VS Code
cd my-api
code .
# Reopen in Container

# 3. Start Claude
claudecopilot

# 4. Ask Claude
> create a fastapi app with user authentication, postgresql database, 
> and crud endpoints for a blog post resource. use pydantic for validation,
> sqlalchemy for orm, and include docker-compose for local development.

# 5. Claude generates everything
# - FastAPI app structure
# - Database models
# - Pydantic schemas
# - Authentication middleware
# - CRUD endpoints
# - Docker compose file
# - Requirements.txt

# 6. Run it
docker-compose up
```

**Total time: 30 minutes.**  
**Cost: $0** (already have Copilot)

## How It Works

Behind the scenes:

```
Claude Code CLI
       ↓
Copilot API Proxy (localhost:4141)
       ↓
GitHub Copilot API
       ↓
Claude / GPT / Gemini Models
```

The `copilot-api` proxy translates Anthropic API calls to GitHub Copilot API calls. Your code never knows the difference!

## Authentication

First time setup:
1. Run `claudecopilot`
2. Visit the URL shown (github.com/login/device)
3. Enter the code
4. Done! Token is saved locally

**That's it.** No API keys to manage, no extra subscriptions.

## Team Benefits

This setup is perfect for teams:

**Standard Configuration**
```bash
# Everyone uses the same devcontainer
# Same models, same settings
# Consistent development environment
```

**Cost Savings**
- ❌ Before: $20/month × 5 developers = $100/month
- ✅ After: $0 (already have Copilot for team)

**Flexible Per-Project**
```
frontend/     → gpt-5-mini (fast)
backend/      → claude-sonnet-4.5 (complex)
ml-service/   → claude-sonnet-4.5 + haiku
docs/         → claude-sonnet-4.5 (quality)
```

## Advanced Features

### 1. Workspace Management

Work with multiple projects simultaneously:

```bash
./setup-workspace.sh
# Choose: Multi-Project
# Mounts: ~/projects/frontend, ~/projects/backend, ~/projects/shared
```

### 2. Model Switching

Change models per-task:
```bash
# Heavy reasoning
ANTHROPIC_MODEL=claude-sonnet-4.5 claudecopilot

# Quick iterations
ANTHROPIC_MODEL=gpt-5-mini claudecopilot

# Long context
ANTHROPIC_MODEL=gemini-2.5-pro claudecopilot
```

### 3. CI/CD Integration

Use the same setup in GitHub Actions:
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: devcontainers/ci@v0.3
        with:
          runCmd: claudecopilot --script generate-tests.sh
```

## Performance Tips

1. **Use gpt-5-mini for simple tasks** (5x faster than Sonnet)
2. **Keep the proxy running** (avoids startup delay)
3. **Enable caching** (bind mounts with `consistency=cached`)
4. **Disable extras for speed** (`DISABLE_NON_ESSENTIAL_MODEL_CALLS=1`)

## Comparison: Claude Pro vs This Setup

| Feature | Claude Pro | This Setup |
|---------|----------|------------|
| **Cost** | $20/month | $0 (included with Copilot) |
| **Models** | Claude only | Claude + GPT + Gemini |
| **IDE Integration** | Limited | Full VS Code support |
| **Team Sharing** | Individual subs | One team subscription |
| **Project Config** | Manual | Automated templates |
| **DevContainers** | No | Yes |
| **CI/CD** | No | Yes |

## Common Questions

**Q: Is this against GitHub's terms of service?**  
A: No! GitHub Copilot explicitly provides these models through their API. We're just making them easier to use.

**Q: Will I hit rate limits?**  
A: Same limits as GitHub Copilot (generous for individual use, unlimited for business).

**Q: What about data privacy?**  
A: Same as GitHub Copilot - your code goes through GitHub's infrastructure.

**Q: Can I use this without Docker?**  
A: Yes! The local installation script works on macOS, Linux, and WSL.

**Q: Does this work with Cursor/other IDEs?**  
A: The proxy works with any tool that supports Anthropic's API format.

## Get Started Now

**New Project:**
```bash
curl -fsSL https://raw.githubusercontent.com/zerolve-io/claude-copilot-setup/main/create-project.sh | bash
```

**Existing Project:**
```json
{
  "features": {
    "ghcr.io/zerolve-io/devcontainer-features/claude-copilot:1": {}
  }
}
```

**GitHub Codespaces:**
[![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/zerolve-io/claude-copilot-setup)

## Resources

- **Main Repository:** [github.com/zerolve-io/claude-copilot-setup](https://github.com/zerolve-io/claude-copilot-setup)
- **DevContainer Feature:** [github.com/zerolve-io/devcontainer-features](https://github.com/zerolve-io/devcontainer-features)
- **Original Article:** [DEV.to post by allentcm](https://dev.to/allentcm/using-claude-code-with-github-copilot-subscription-2obj)

## Conclusion

If you're already paying for GitHub Copilot, you're sitting on access to Claude Sonnet 4.5, GPT-5, Gemini 2.5 Pro, and more. Why pay extra for Claude Pro?

With this setup, you get:
- ✅ Multiple AI models through one subscription
- ✅ Project-specific configurations
- ✅ Team-ready environments
- ✅ Full DevContainer support
- ✅ Zero additional cost

**Stop paying for multiple AI subscriptions. Start using what you already have.**

---

*Built with ❤️ by developers, for developers. Contributions welcome!*

**Tags:** #Claude #GitHubCopilot #AI #DevContainers #VSCode #Development #OpenSource
