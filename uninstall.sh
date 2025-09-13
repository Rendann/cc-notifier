#!/bin/bash

# Claude Code Notifier Uninstaller
# Removes notification hooks for Claude Code on macOS

set -e

# Installation directory
INSTALL_DIR="$HOME/.claude-code-notifier"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
SESSION_DIR="/tmp/claude_window_session"

echo "🗑️  Uninstalling Claude Code Notifier..."
echo "📁 Installation directory: $INSTALL_DIR"

# Remove installation directory and all contents
if [[ -d "$INSTALL_DIR" ]]; then
    echo "🔧 Removing installation directory..."
    rm -rf "$INSTALL_DIR"
    echo "✅ Installation directory removed"
else
    echo "ℹ️  Installation directory not found (already removed or never installed)"
fi

# Remove temporary session files
if [[ -d "$SESSION_DIR" ]]; then
    echo "🔧 Removing session directory and temporary files..."
    rm -rf "$SESSION_DIR"
    echo "✅ Session directory removed"
else
    echo "ℹ️  Session directory not found (already removed or no active sessions)"
fi

# Check if Claude settings file exists
if [[ -f "$CLAUDE_SETTINGS" ]]; then
    echo "⚙️  Checking Claude settings..."
    
    # Check if our hooks are configured
    if grep -q "claude-code-notifier" "$CLAUDE_SETTINGS" 2>/dev/null; then
        echo ""
        echo "📋 Manual step required:"
        echo "Remove the hook configuration from: $CLAUDE_SETTINGS"
        echo ""
        echo "Look for and remove the 'hooks' section containing:"
        echo "- SessionStart hook pointing to $INSTALL_DIR/cc-notifier-init.sh"
        echo "- Stop hook pointing to $INSTALL_DIR/cc-notifier-notify.sh"
        echo "- Notification hook pointing to $INSTALL_DIR/cc-notifier-notify.sh"
        echo "- SessionEnd hook pointing to $INSTALL_DIR/cc-notifier-cleanup.sh"
        echo ""
        echo "Or remove just the hook entries if other hooks exist."
    else
        echo "✅ No Claude Code notifier hooks found in settings"
    fi
else
    echo "ℹ️  Claude settings file not found"
fi

echo ""
echo "🎉 Uninstallation complete!"
echo ""
echo "📋 What was removed:"
echo "- Hook scripts from $INSTALL_DIR"
echo "- Installation directory"
echo "- Session directory and temporary files from /tmp/claude_window_session"
echo ""
echo "📋 Manual cleanup (if needed):"
echo "- Remove hook configuration from ~/.claude/settings.json"
echo "- Dependencies (jq, terminal-notifier, Hammerspoon) were left installed"
echo ""
echo "Thank you for using Claude Code Notifier! 👋"