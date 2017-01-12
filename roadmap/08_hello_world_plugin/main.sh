#!/bin/bash
# make sure that you have custom docker
# make sure you have goolang env set upbibtex
# go get docker_graphdriver_plugins/hello_world
export SESSION="session_08"

. exported.sh
f08_load_dependencies
standard_init

tmux_start_session "$SESSION"
tmux_exec "f08_load_dependencies"
# tmux_exec f02_start_new_daemon

tmux split-window -h
tmux_exec ". exported.sh"
tmux_exec "f08_load_dependencies"
tmux_exec "f05_setup_golang_env"
tmux_exec "f08_get_hello_world_plugin"
tmux_exec "sudo $WORKDIR/hello_world"

tmux send-keys -t 0 "f02_start_new_daemon --experimental -s test_graph -D" C-m

tmux split-window -v

tmux attach

f08_cleanup
