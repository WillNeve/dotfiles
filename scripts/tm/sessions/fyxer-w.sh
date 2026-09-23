#!/bin/bash
# Fyxer Web App tmux session: left column (3 panes) + right full-height.
# Left: top = pnpm i + build; middle = app:dev after 35s; bottom = functions:dev after 25s. Right: opencode.

# Configuration
SESSION_NAME="Web App"
WINDOW1_NAME="Main"
PROJECT_DIR="/Users/will/code/work/fyxer/web-app"

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
#   split-v 0.1     → 0.0=top-left, 0.1=middle-left, 0.2=bottom-left, 0.3=right
tmux rename-window -t "$SESSION_NAME":0 "$WINDOW1_NAME"
tmux split-window -h -t "$SESSION_NAME":0 -c "$PROJECT_DIR"
tmux resize-pane -t "$SESSION_NAME":0.0 -x 40%
tmux split-window -v -t "$SESSION_NAME":0.0 -c "$PROJECT_DIR"
tmux split-window -v -t "$SESSION_NAME":0.1 -c "$PROJECT_DIR"

# Pane 0.0 (top-left): install deps and build
tmux send-keys -t "$SESSION_NAME":0.0 "pnpm i && pnpm build" C-m
# Pane 0.1 (middle-left): app dev server after 35s wait
tmux send-keys -t "$SESSION_NAME":0.1 "sleep 40 && pnpm run app:dev" C-m
# Pane 0.2 (bottom-left): functions dev server after 25s wait
tmux send-keys -t "$SESSION_NAME":0.2 "sleep 30 && pnpm run functions:dev" C-m
# Pane 0.3 (right, full height): opencode
tmux send-keys -t "$SESSION_NAME":0.3 "opencode" C-m

tmux select-pane -t "$SESSION_NAME":0.0
tmux select-window -t "$SESSION_NAME":0

# Attach or switch into session
if [ -n "$TMUX" ]; then
    tmux switch-client -t "$SESSION_NAME"
else
    tmux attach-session -t "$SESSION_NAME"
fi
