#!/bin/bash

# Claude Code Notifier Installer
# Installs notification hooks for Claude Code on macOS

set -e

# Installation directory
INSTALL_DIR="$HOME/.claude-code-notifier"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

echo "🚀 Installing Claude Code Notifier..."
echo "📁 Installation directory: $INSTALL_DIR"

# Check dependencies
echo "📋 Checking dependencies..."

# Check Hammerspoon CLI
HAMMERSPOON_CLI="/Applications/Hammerspoon.app/Contents/Frameworks/hs/hs"
if [[ ! -f "$HAMMERSPOON_CLI" ]]; then
    echo "❌ Hammerspoon CLI not found at $HAMMERSPOON_CLI"
    echo "   Please install Hammerspoon from https://www.hammerspoon.org/ then install the Hammerspoon CLI using \"hs.ipc.cliInstall()\" from the Hammerspoon console."
    exit 1
fi

# Check jq
if ! command -v jq &>/dev/null; then
    echo "❌ jq is required but not installed. Installing..."
    if command -v brew &>/dev/null; then
        brew install jq
    else
        echo "❌ Homebrew not found. Please install jq manually: https://stedolan.github.io/jq/"
        exit 1
    fi
fi

# Check terminal-notifier
if ! command -v terminal-notifier &>/dev/null; then
    echo "❌ terminal-notifier is required but not installed. Installing..."
    if command -v brew &>/dev/null; then
        brew install terminal-notifier
    else
        echo "❌ Homebrew not found. Please install terminal-notifier manually"
        exit 1
    fi
fi

echo "✅ Dependencies check complete"

# Create installation directory
echo "🔧 Setting up installation directory..."
mkdir -p "$INSTALL_DIR"

# Get the directory where this install script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy hook scripts to installation directory
echo "📋 Installing hook scripts..."
cp "$SCRIPT_DIR/src/lib.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/src/cc-notifier-init.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/src/cc-notifier-cleanup.sh" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/src/cc-notifier-notify.sh" "$INSTALL_DIR/"

# Make scripts executable
chmod +x "$INSTALL_DIR"/*.sh
echo "✅ Scripts installation complete"

# Test notification permissions
echo "🔔 Testing notification permissions..."
terminal-notifier -message "Claude Code Notifier is ready!" -title "Setup Complete" -sound "Funk"

# Check if Claude settings file exists
if [[ ! -f "$CLAUDE_SETTINGS" ]]; then
    echo "📁 Creating Claude settings directory..."
    mkdir -p "$(dirname "$CLAUDE_SETTINGS")"
fi

# Generate hook configuration using jq for clean, validated JSON
echo "⚙️  Generating hook configuration..."

# Create hook configuration with jq (ensures valid JSON)
HOOK_CONFIG=$(jq -n \
  --arg session_start "$INSTALL_DIR/cc-notifier-init.sh" \
  --arg stop "$INSTALL_DIR/cc-notifier-notify.sh" \
  --arg session_end "$INSTALL_DIR/cc-notifier-cleanup.sh" \
  '{
    "hooks": {
      "SessionStart": [{"matcher": "", "hooks": [{"type": "command", "command": $session_start}]}],
      "Stop": [{"matcher": "", "hooks": [{"type": "command", "command": $stop}]}],
      "Notification": [{"matcher": "", "hooks": [{"type": "command", "command": $stop}]}],
      "SessionEnd": [{"matcher": "", "hooks": [{"type": "command", "command": $session_end}]}]
    }
  }')

echo ""
echo "📋 Add this to your ~/.claude/settings.json:"
echo ""
echo "$HOOK_CONFIG"
echo ""
echo "   Note: If you already have a 'hooks' section, merge the hook types accordingly."

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📖 How it works:"
echo "1. When you start a Claude Code session, it captures your current window"
echo "2. When Claude finishes and you've switched to another app, you get a notification"
echo "3. Click the notification to return to your original window"
echo "4. If you're still on the original window, no notification is sent"
echo ""
echo "📁 Installed at: $INSTALL_DIR"
echo "⚙️  Configuration: ~/.claude/settings.json"
echo ""
echo "Happy coding! 🚀"