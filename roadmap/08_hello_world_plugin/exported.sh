#!/bin/bash
export HELLO_WORLD_PLUGIN_PATH="github.com/atlantic777/docker_graphdriver_plugins/hello_world"

function f08_load_dependencies {
    . ../common.sh
    . ../02_build_master_docker/exported.sh
    . ../05_talking_to_docker_registry/exported.sh
}

function f08_get_hello_world_plugin {
    cd "$WORKDIR"

    go get -v "$HELLO_WORLD_PLUGIN_PATH"
    go build -v "$HELLO_WORLD_PLUGIN_PATH"
}

function f08_cleanup {
    rm -rfv "$WORKDIR"
}
