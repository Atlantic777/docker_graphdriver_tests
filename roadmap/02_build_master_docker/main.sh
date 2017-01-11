#!/bin/bash
. exported.sh

export WORKDIR="$PWD/workdir"
export SESSION="session_02"

# create working dir
mkdir -p "$WORKDIR"

# start tmux
tmux new -s "$SESSION" -d "bash"
tmux send-keys ". exported.sh" C-m
tmux send-keys ". ../01_obtain_dockerd/exported.sh" C-m

clone_repo
tmux send-keys "download_binary" C-m
tmux send-keys "start_dockerd" C-m

tmux split-window -h
tmux send-keys ". exported.sh" C-m
tmux send-keys ". ../01_obtain_dockerd/exported.sh" C-m

tmux send-keys -t 1 "build_docker; stop_old_daemon; start_new_daemon" C-m

tmux attach -t "$SESSION"

rm -rfv "$WORKDIR"