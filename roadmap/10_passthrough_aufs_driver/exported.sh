#!/bin/bash
export PLUGINS_PATH="github.com/atlantic777/docker_graphdriver_plugins"
export PASSTHROUGH_PLUGIN_PATH="$PLUGINS_PATH/aufs_passthrough"

function f10_load_dependencies {
    . ../common.sh
    . ../02_build_master_docker/exported.sh
    . ../05_talking_to_docker_registry/exported.sh
}

function f10_get_passthrough_aufs_plugin {
    pushd "$WORKDIR"
    go build "$PASSTHROUGH_PLUGIN_PATH"
    popd
}

function f10_start_aufs_plugin {
    pushd "$WORKDIR"
    sudo ./aufs_passthrough
    popd
}

function f10_cleanup {
    rm -rfv "$WORKDIR"
}
