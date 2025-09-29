#!/bin/bash

# Configuration Variables (Customize these!)
SESSION_NAME="Fyxer web-app"  # Name of the tmux session
WINDOW1_NAME="Main"        # Name of the first window
WINDOW2_NAME="Servers"     # Name of the second window
PROJECT_DIR="/Users/willneve/willneve/work/fyxer/web-app"

# Check if the session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "Session '$SESSION_NAME' already exists. Attaching..."
    tmux attach-session -t "$SESSION_NAME"
    exit 0
fi

# Create a new detached session
echo "Creating new session '$SESSION_NAME'..."
tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Set up Window 1: Main window with two panes (vertical split)
tmux rename-window -t "$SESSION_NAME":0 "$WINDOW1_NAME"  # Rename the default window
tmux split-window -h -t "$SESSION_NAME":0 -c "$PROJECT_DIR"  # Vertical split (left: main, right: opencode)
tmux resize-pane -t "$SESSION_NAME":0.0 -x 70%  # Make main pane 70% width

# Set commands for Window 1 panes
tmux send-keys -t "$SESSION_NAME":0.0 "gst" C-m  # Git status in main pane
tmux send-keys -t "$SESSION_NAME":0.1 "opencode" C-m  # Opencode in right pane

tmux select-pane -t "$SESSION_NAME":0.0  # Select the main pane by default

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
tmux send-keys -t "$SESSION_NAME":1.0 "ggl && npm i" C-m

# Pane 1 (top-right): sync-functions (first distribute in shared, then build:watch)
tmux send-keys -t "$SESSION_NAME":1.1 "cd shared && npm i && npm run distribute && cd ../sync-functions && npm i && npm run build:watch" C-m

# Pane 2 (bottom-left): functions build:watch
tmux send-keys -t "$SESSION_NAME":1.2 "cd functions && npm i && npm run build:watch" C-m

# Pane 3 (bottom-right): functions dev
tmux send-keys -t "$SESSION_NAME":1.3 "cd functions && npm run dev" C-m

# Wait a moment for initial setup, then run the app dev command
tmux send-keys -t "$SESSION_NAME":1.0 "sleep 5 && cd app && npm i && npm run dev" C-m

# Switch back to Window 1 by default
tmux select-window -t "$SESSION_NAME":0

# Attach to the session
tmux attach-session -t "$SESSION_NAME"
