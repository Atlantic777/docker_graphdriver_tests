#!/bin/bash
export SESSION="session_05"
. exported.sh
f05_load_dependencies
standard_init

tmux_start_session "$SESSION"
tmux_exec "f05_setup_golang_env"
tmux_exec "f05_get_docker2cvmfs_tool"

tmux attach

# tests should be:
# - get manifest
# - get config
# - get layers

f05_cleanup
