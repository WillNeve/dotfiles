#!/bin/bash
SESSION_NAME="localista"
PROJECT_PATH="$HOME/localista/localista-app"

tmux new-session -d -s $SESSION_NAME

tmux rename-window -t $SESSION_NAME:0 'server'
tmux split-window -h -t $SESSION_NAME:0
tmux split-window -v -t $SESSION_NAME:0.1

tmux new-window -t $SESSION_NAME:1 -n 'main'
tmux new-window -t $SESSION_NAME:2 -n 'htop'

sleep 0.5 # shell startup time
tmux send-keys -t $SESSION_NAME:0.0 "cd $PROJECT_PATH && clear" C-m
tmux send-keys -t $SESSION_NAME:0.1 "cd $PROJECT_PATH && clear" C-m
tmux send-keys -t $SESSION_NAME:0.2 "cd $PROJECT_PATH && clear" C-m
tmux send-keys -t $SESSION_NAME:1 "cd $PROJECT_PATH && clear" C-m
tmux send-keys -t $SESSION_NAME:2 "htop" C-m
sleep 0.3 # cd and clear time
tmux send-keys -t $SESSION_NAME:0.0 "npm run emailengine" C-m
tmux send-keys -t $SESSION_NAME:0.1 "npm run dev" C-m
tmux send-keys -t $SESSION_NAME:0.2 "prisma studio" C-m
tmux send-keys -t $SESSION_NAME:1 "code . && git fetch && clear && git status" C-m
sleep 0.2
tmux select-window -t $SESSION_NAME:1
tmux select-pane -t 0

tmux attach-session -t $SESSION_NAME
