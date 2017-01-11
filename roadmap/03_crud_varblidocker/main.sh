#!/bin/bash

. exported.sh
. ../01_obtain_dockerd/exported.sh
. ../02_build_master_docker/exported.sh

export WORKDIR="$PWD/workdir"
export SESSION="session_03"

# create workdir
mkdir -p "$WORKDIR"

# start tmux
tmux new -s "$SESSION" -d "bash"
tmux send-keys ".exported.sh" C-m
tmux send-keys ". ../01_obtain_dockerd/exported.sh" C-m
tmux send-keys ". ../02_build_master_docker/exported.sh" C-m

clone_repo
tmux send-keys "download_binary" C-m
tmux send-keys "start_dockerd" C-m

tmux split-window -h
tmux send-keys ". exported.sh" C-m
tmux send-keys ". ../01_obtain_dockerd/exported.sh" C-m
tmux send-keys ". ../02_build_master_docker/exported.sh" C-m

tmux send-keys -t 1 "build_docker; stop_old_daemon" C-m
tmux send-keys -t 0 "start_new_daemon" C-m

tmux attach -t "$SESSION"

rm -rfv "$WORKDIR"
