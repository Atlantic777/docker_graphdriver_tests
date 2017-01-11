#!/bin/bash
export SESSION="session_01"

. exported.sh
f01_load_dependencies
standard_init

f01_install_docker

tmux_start_session "$SESSION"
tmux_exec "f01_start_dockerd"

tmux split-window -h
tmux attach -t "$SESSION"

cleanup
