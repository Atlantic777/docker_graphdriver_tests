#!/bin/bash
export WORKDIR="$PWD/workdir"
export SESSION="session_01"

. exported.sh

# create working dir
mkdir -p "$WORKDIR"

# start tmux
tmux new -s "$SESSION" -d "bash"
tmux send-keys ". exported.sh" C-m

# download binary
download_binary

# start dockerd
tmux send-keys "start_dockerd" C-m

# attach tmux
tmux attach -t "$SESSION"

# cleanup after exit
cleanup
