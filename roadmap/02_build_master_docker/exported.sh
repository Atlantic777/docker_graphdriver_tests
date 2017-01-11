#!/bin/bash

function f02_load_dependencies {
    . ../common.sh
    . ../01_obtain_dockerd/exported.sh
    export C2_REPO_URL="https://github.com/docker/docker"
    export C2_CACHE="$(pwd)/../../cache/02"
    export C2_LOCAL_REPO_PATH="$C2_CACHE/docker-repo"
}

# function clone_repo {
#     git clone "$REPO_URL" "$WORKDIR/$REPO_NAME"
# }
function f02_clone_repo {
    if [ ! -e "$LOCAL_REPO_PATH" ]; then
        git clone "$C2_REPO_URL" "$C2_LOCAL_REPO_PATH"
    fi
    cp -r "$C2_LOCAL_REPO_PATH" "$WORKDIR/docker-repo"
}

function build_docker {
    cd "$WORKDIR/$REPO_NAME"
    make binary
}

function f02_build_docker {
    pushd "$WORKDIR/docker-repo"
    make binary
    popd
}

function stop_old_daemon {
    sudo killall dockerd
}

function start_new_daemon {
    echo "Starting new daemon"
    sudo rm -rf /var/lib/docker
    sudo "$WORKDIR/$REPO_NAME/bundles/latest/binary-daemon/dockerd" -D -s aufs
}

function f02_copy_binaries {
    local BUNDLES="$WORKDIR/docker-repo/bundles/latest/"
    mkdir -p "$C2_CACHE/bin"
    cp -v `find $BUNDLES -name docker*` "$C2_CACHE/bin"
}

function f02_get_binaries {
    if [ ! -e "$C2_CACHE/bin" ]; then
        f01_install_docker
        f01_start_dockerd &

        f02_clone_repo
        f02_build_docker
        sudo killall dockerd

        f02_copy_binaries
    else
        echo "Build not necessary"
    fi
}

function f02_start_new_daemon {
    f02_get_binaries
    sudo $C2_CACHE/bin/dockerd -D
}
