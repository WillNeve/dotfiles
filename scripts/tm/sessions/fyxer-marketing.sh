#!/bin/bash

# Configuration Variables (Customize these!)
SESSION_NAME="Fyxer Marketing"  # Name of the tmux session
WINDOW1_NAME="Main"        # Name of the first window
WINDOW2_NAME="Servers"     # Name of the second window
PROJECT_DIR="/Users/willneve/code/work/fyxer/landing-pages"

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

# Set up Window 2: Servers window with 2 columns
tmux new-window -t "$SESSION_NAME":1 -n "$WINDOW2_NAME" -c "$PROJECT_DIR"

# Create the 2-pane layout: vertical split (left/right columns)
tmux split-window -h -t "$SESSION_NAME":1 -c "$PROJECT_DIR"
tmux resize-pane -t "$SESSION_NAME":1.0 -x 50%  # Make each column 50% width

# Pane 0 (left): npm run dev
tmux send-keys -t "$SESSION_NAME":1.0 "npm run dev" C-m

# Pane 1 (right): npm run ngrok
tmux send-keys -t "$SESSION_NAME":1.1 "npm run ngrok" C-m

# Switch back to Window 1 by default
tmux select-window -t "$SESSION_NAME":0

# Attach or switch to the session
if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach-session -t "$SESSION_NAME"
fi
