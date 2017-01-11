#!/bin/bash
export SESSION="session_02"

. exported.sh
f02_load_dependencies
standard_init

tmux_start_session "$SESSION"

tmux_exec "f02_load_dependencies"
tmux_exec "f02_start_new_daemon"

tmux_split
tmux_exec "f02_load_dependencies"

tmux attach -t "$SESSION"

sudo killall dockerd
rm -rf "$WORKDIR"
