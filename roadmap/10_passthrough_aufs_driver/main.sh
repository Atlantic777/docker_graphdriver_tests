#!/bin/bash
export SESSION="session_10"
. exported.sh
f10_load_dependencies
standard_init

tmux_start_session "$SESSION"
tmux_exec "f10_load_dependencies"

tmux split-window -h
tmux_exec ". exported.sh"
tmux_exec "f10_load_dependencies"
tmux_exec "f05_setup_golang_env"
tmux_exec "f10_get_passthrough_aufs_plugin"
tmux_exec "f10_start_aufs_plugin"

while [ ! -e "$WORKDIR/aufs_passthrough" ]; do
    sleep 1
done;

tmux send-keys -t 0 "f02_start_new_daemon --experimental -s aufs_passthrough -D" C-m
tmux split-window -v

tmux attach

f10_cleanup
