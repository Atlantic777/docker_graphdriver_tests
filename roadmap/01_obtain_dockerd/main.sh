#!/bin/bash
export SESSION="session_01"

. exported.sh
f01_load_dependencies
standard_init

# start tmux
tmux new -s "$SESSION" -d "bash"
tmux send-keys ". exported.sh" C-m

# download binary
download_binary

# start dockerd
tmux send-keys "start_dockerd" C-m

tmux split-window -h

# attach tmux
tmux attach -t "$SESSION"

# cleanup after exit
cleanup
