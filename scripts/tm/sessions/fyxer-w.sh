#!/bin/bash

# Configuration Variables (Customize these!)
SESSION_NAME="Fyxer web-app"  # Name of the tmux session
WINDOW1_NAME="Main"        # Name of the first window
WINDOW2_NAME="Servers"     # Name of the second window
PROJECT_DIR="/Users/willneve/code/work/fyxer/web-app"

# Check if the session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Switching..."
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$SESSION_NAME"
    else
        tmux attach-session -t "$SESSION_NAME"
    fi
    exit 0
fi

# Create a new detached session in project directory
echo "Creating new session '$SESSION_NAME'..."
tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Set up Window 1: Main window with two columns
tmux rename-window -t "$SESSION_NAME":0 "$WINDOW1_NAME"  # Rename the default window
tmux split-window -h -t "$SESSION_NAME":0 -c "$PROJECT_DIR"  # Vertical split (left: working, right: opencode)
tmux resize-pane -t "$SESSION_NAME":0.0 -x 50%  # Make each column 50% width

# Set commands for Window 1 panes
# Pane 0 (left column): working shell

# Pane 1 (right): opencode
tmux send-keys -t "$SESSION_NAME":0.1 "opencode" C-m

tmux select-pane -t "$SESSION_NAME":0.0  # Select the working pane by default

# Set up Window 2: Servers window with 4 panes
tmux new-window -t "$SESSION_NAME":1 -n "$WINDOW2_NAME" -c "$PROJECT_DIR"

# Create the 4-pane layout: 2x2 grid
# Start with vertical split (left/right columns)
tmux split-window -h -t "$SESSION_NAME":1 -c "$PROJECT_DIR"

# Split left column horizontally (top-left, bottom-left)
tmux split-window -v -t "$SESSION_NAME":1.0 -c "$PROJECT_DIR"

# Split right column horizontally (top-right, bottom-right)
tmux split-window -v -t "$SESSION_NAME":1.1 -c "$PROJECT_DIR"

# Run initial setup commands in repo root (pane 0 - top-left)
tmux send-keys -t "$SESSION_NAME":1.0 "pnpm i" C-m

# Pane 1 (top-right): sync-functions build:watch
tmux send-keys -t "$SESSION_NAME":1.1 "cd sync-functions && pnpm run build:watch" C-m

# Pane 2 (bottom-left): functions build:watch
tmux send-keys -t "$SESSION_NAME":1.2 "cd functions && pnpm run build:watch" C-m

# Pane 3 (bottom-right): functions dev
tmux send-keys -t "$SESSION_NAME":1.3 "cd functions && (command -v kill-port >/dev/null 2>&1 && kill-port 8085 || true) && pnpm run dev" C-m

# Run the app dev command (pane 0 continues after install)
tmux send-keys -t "$SESSION_NAME":1.0 "cd app && (command -v kill-port >/dev/null 2>&1 && kill-port 5173 || true) && pnpm run dev" C-m

# Switch back to Window 1 by default
tmux select-window -t "$SESSION_NAME":0

# Attach or switch to the session
if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach-session -t "$SESSION_NAME"
fi
