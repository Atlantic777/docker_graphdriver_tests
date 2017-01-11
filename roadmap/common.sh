#!/bin/bash

function standard_init {
    export WORKDIR="$PWD/workdir"
    mkdir -p "$WORKDIR"
}

function tmux_start_session {
    tmux new -s "$1" -d "bash"
    tmux_exec ". exported.sh"
}

function tmux_exec {
    local CMD="$1"
    tmux send-keys "$CMD" C-m
}

function tmux_split {
    tmux split-window -h
    tmux_exec ". exported.sh"
}
