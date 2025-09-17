#!/bin/bash

# Claude Code Notifier Uninstaller
# Removes notification hooks for Claude Code on macOS

set -e

# Installation directories
BIN_DIR="$HOME/.local/bin"
SHARE_DIR="$HOME/.local/share/cc-notifier"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
SESSION_DIR="/tmp/claude_code_notifier"

echo "🗑️  Uninstalling Claude Code Notifier..."

# Remove installation files
if [[ -f "$BIN_DIR/cc-notifier" ]]; then
    echo "🔧 Removing command from $BIN_DIR..."
    rm -f "$BIN_DIR/cc-notifier"
    echo "✅ Command removed"
else
    echo "ℹ️  Command not found at $BIN_DIR/cc-notifier"
fi

if [[ -d "$SHARE_DIR" ]]; then
    echo "🔧 Removing support files from $SHARE_DIR..."
    rm -rf "$SHARE_DIR"
    echo "✅ Support files removed"
else
    echo "ℹ️  Support directory not found at $SHARE_DIR"
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
        echo "- SessionStart hook with 'cc-notifier init' or '$BIN_DIR/cc-notifier init'"
        echo "- Stop hook with 'cc-notifier notify' or '$BIN_DIR/cc-notifier notify'"
        echo "- Notification hook with 'cc-notifier notify' or '$BIN_DIR/cc-notifier notify'"
        echo "- SessionEnd hook with 'cc-notifier cleanup' or '$BIN_DIR/cc-notifier cleanup'"
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
echo "- Hook scripts from $SHARE_DIR"
echo "- Installation directory"
echo "- Session directory and temporary files from /tmp/claude_code_notifier"
echo ""
echo "📋 Manual cleanup (if needed):"
echo "- Remove hook configuration from ~/.claude/settings.json"
echo "- Dependencies (jq, terminal-notifier, Hammerspoon) were left installed"
echo ""
echo "Thank you for using Claude Code Notifier! 👋"