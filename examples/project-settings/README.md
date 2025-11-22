# Project-Specific Settings Examples

Claude Code allows you to customize settings per-project by placing a `.claude/settings.json` file in your project directory.

## Basic Structure

```json
{
  "env": {
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini"
  }
}
```

## Examples by Project Type

### Python Machine Learning Project

For computationally intensive work requiring deep reasoning:

```json
{
  "env": {
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-4.5",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "0"
  }
}
```

**Why:**
- Use full Sonnet for complex ML algorithms
- Use Claude Haiku for faster iterations
- Enable extended model features

### Simple Website / Frontend Project

For quick iterations and fast feedback:

```json
{
  "env": {
    "ANTHROPIC_MODEL": "gpt-5-mini",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1"
  }
}
```

**Why:**
- Faster responses for simple HTML/CSS/JS
- Cost-effective for straightforward tasks
- Minimal overhead

### Documentation Project

Balanced between quality and speed:

```json
{
  "env": {
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "1"
  }
}
```

**Why:**
- Sonnet for high-quality writing
- Fast model for simple formatting
- Disable extras to speed up editing

### Backend API Development

For complex business logic:

```json
{
  "env": {
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-4o",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "0"
  }
}
```

**Why:**
- Sonnet for complex API design
- GPT-4o for solid code completion
- Enable full features for debugging

### Legacy Code Refactoring

When working with complex codebases:

```json
{
  "env": {
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "claude-haiku-4.5",
    "DISABLE_NON_ESSENTIAL_MODEL_CALLS": "0",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "0"
  }
}
```

**Why:**
- Sonnet for understanding complex logic
- Claude models for consistency
- Enable all features for thorough analysis

## Environment Variables Reference

| Variable | Default | Description |
|----------|---------|-------------|
| `ANTHROPIC_BASE_URL` | `http://localhost:4141` | Copilot API proxy URL (don't change) |
| `ANTHROPIC_AUTH_TOKEN` | `sk-dummy` | Auth token (don't change when using proxy) |
| `ANTHROPIC_MODEL` | `claude-sonnet-4.5` | Primary model for main tasks |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `gpt-5-mini` | Fast model for quick tasks |
| `DISABLE_NON_ESSENTIAL_MODEL_CALLS` | `1` | Disable extra features for speed (0=enable, 1=disable) |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | `1` | Reduce network calls (0=enable, 1=disable) |

## How Settings Are Applied

1. **Global settings** from `~/.claude/settings.json` (installed by default)
2. **Project settings** from `<project>/.claude/settings.json` (override global)
3. **Environment variables** in your shell (highest priority)

### Example Priority:

```bash
# Global: claude-sonnet-4.5
# Project: gpt-5-mini
# Result: Uses gpt-5-mini (project wins)

# If you run:
ANTHROPIC_MODEL=gpt-4o claudecopilot
# Result: Uses gpt-4o (env var wins)
```

## Creating Project Settings

### Method 1: Copy and Modify

```bash
# In your project directory
mkdir -p .claude
cp ~/.claude/settings.json .claude/settings.json
# Edit .claude/settings.json
```

### Method 2: Create from Scratch

```bash
# In your project directory
mkdir -p .claude
cat > .claude/settings.json << 'EOF'
{
  "env": {
    "ANTHROPIC_MODEL": "claude-sonnet-4.5",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini"
  }
}
EOF
```

### Method 3: Use Example Templates

Copy from this repository:

```bash
cp examples/project-settings/python-ml.json .claude/settings.json
```

## Gitignore Recommendation

**Should you commit `.claude/settings.json`?**

**Yes, if:**
- ✅ Settings are specific to the project type
- ✅ Team should use the same models
- ✅ Optimize for project characteristics

**No, if:**
- ❌ Settings are personal preferences
- ❌ Team members have different Copilot access
- ❌ Settings contain sensitive info (they shouldn't)

### Add to `.gitignore`:

```
# Personal Claude preferences
.claude/personal.json

# But commit project defaults
# .claude/settings.json
```

## Model Selection Guide

### When to use `claude-sonnet-4.5`:
- Complex reasoning required
- Code architecture decisions
- Bug investigation
- Technical writing

### When to use `claude-haiku-4.5`:
- Quick code generation
- Simple refactoring
- Test writing
- Documentation formatting

### When to use `gpt-5-mini`:
- Fastest responses
- Simple completions
- Repetitive tasks
- Budget-conscious projects

### When to use `gpt-4o`:
- Good balance of speed/quality
- Multi-modal tasks
- Complex code completion

### When to use `gemini-2.5-pro`:
- Long context windows needed
- Large codebase analysis
- Multi-file refactoring

## Advanced: Dynamic Settings

You can create a script to switch settings based on context:

```bash
# ~/bin/claude-set-model
#!/bin/bash
MODEL=$1
cat > .claude/settings.json << EOF
{
  "env": {
    "ANTHROPIC_MODEL": "${MODEL}",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "gpt-5-mini"
  }
}
EOF
echo "✓ Set model to ${MODEL}"
```

Usage:
```bash
claude-set-model claude-sonnet-4.5
```

## Troubleshooting

### Settings not applied

1. Check file location: `.claude/settings.json` (note the dot!)
2. Validate JSON syntax: `cat .claude/settings.json | python -m json.tool`
3. Restart Claude Code: Exit and run `claudecopilot` again

### Which settings are active?

Claude Code shows the current model in the UI. You can also check:

```bash
echo $ANTHROPIC_MODEL
```

### Test settings

```bash
# Quick test
cat .claude/settings.json
claudecopilot
# Look for model name in the UI
```
