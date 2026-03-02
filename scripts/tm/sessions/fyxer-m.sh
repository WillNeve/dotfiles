#!/bin/bash
# Fyxer Landing Pages tmux session: left column (2 panes) + right full-height.
# Left: top = working shell, bottom = spare. Right: npm run dev + opencode.

# Configuration
SESSION_NAME="Landing Pages"
WINDOW1_NAME="Main"
PROJECT_DIR="/Users/willneve/code/work/fyxer/landing-pages"

# Reuse existing session if present
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Switching..."
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$SESSION_NAME"
    else
        tmux attach-session -t "$SESSION_NAME"
    fi
    exit 0
fi

# Create detached session in project directory
echo "Creating new session '$SESSION_NAME'..."
tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Layout (pane indices are positional — top-to-bottom, left-to-right — and shift after each split):
#   split-h         → 0.0=left, 0.1=right
#   split-v 0.0     → 0.0=top-left, 0.1=bottom-left, 0.2=right
tmux rename-window -t "$SESSION_NAME":0 "$WINDOW1_NAME"
tmux split-window -h -t "$SESSION_NAME":0 -c "$PROJECT_DIR"
tmux resize-pane -t "$SESSION_NAME":0.0 -x 40%
tmux split-window -v -t "$SESSION_NAME":0.0 -c "$PROJECT_DIR"

# Pane 0.0 (top-left): working shell
# Pane 0.1 (bottom-left): dev server
tmux send-keys -t "$SESSION_NAME":0.1 "npm run dev" C-m
# Pane 0.2 (right, full height): opencode
tmux send-keys -t "$SESSION_NAME":0.2 "opencode" C-m

tmux select-pane -t "$SESSION_NAME":0.0

# Attach or switch into session
if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach-session -t "$SESSION_NAME"
fi
