#!/bin/bash
SESSION_NAME="localista"
PROJECT_PATH="$HOME/localista/localista-app"

tmux new-session -d -s $SESSION_NAME

tmux rename-window -t $SESSION_NAME:0 'server'
tmux split-window -h -t $SESSION_NAME:0
tmux split-window -v -t $SESSION_NAME:0.1

tmux new-window -t $SESSION_NAME:1 -n 'main'

tmux new-window -t $SESSION_NAME:2 -n 'htop'

sleep 0.2
tmux send-keys -t $SESSION_NAME:0.0 "cd $PROJECT_PATH && npm run emailengine" C-m
sleep 0.2
tmux send-keys -t $SESSION_NAME:0.1 "cd $PROJECT_PATH && npm run dev" C-m
sleep 0.2
tmux send-keys -t $SESSION_NAME:0.2 "cd $PROJECT_PATH && prisma studio" C-m
sleep 0.2
tmux send-keys -t $SESSION_NAME:1 "cd $PROJECT_PATH && git fetch && git status" C-m
sleep 0.2
tmux send-keys -t $SESSION_NAME:2 "htop" C-m

# Select window 2 and the first pane
tmux select-window -t $SESSION_NAME:1
tmux select-pane -t 0
# Attach to session
tmux attach-session -t $SESSION_NAME
