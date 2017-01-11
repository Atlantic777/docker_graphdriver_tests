#!/bin/bash
REPO_URL="https://github.com/docker/docker"
REPO_NAME="docker-repo"

function clone_repo {
    git clone "$REPO_URL" "$WORKDIR/$REPO_NAME"
}

function build_docker {
    cd "$WORKDIR/$REPO_NAME"
    make binary
}

function stop_old_daemon {
    sudo killall dockerd
}

function start_new_daemon {
    echo "Starting new daemon"
    sudo rm -rf /var/lib/docker
    sudo "$WORKDIR/$REPO_NAME/bundles/latest/binary-daemon/dockerd" -D -s aufs
}
