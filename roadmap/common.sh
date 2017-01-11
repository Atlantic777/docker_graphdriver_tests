#!/bin/bash

function standard_init {
    export WORKDIR="$PWD/workdir"
    mkdir -p "$WORKDIR"
}
