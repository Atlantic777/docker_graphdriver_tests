#!/bin/bash
DOWNLOAD_URL="https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz"
DOCKER_ARCHIVE_OUT="docker-latest.tgz"

function download_binary {
    echo "Downloading binary to $WORKDIR"

    wget "$DOWNLOAD_URL" -O "$WORKDIR/$DOCKER_ARCHIVE_OUT"
    tar xvf "$WORKDIR/$DOCKER_ARCHIVE_OUT" -C "$WORKDIR"
    sudo cp -v $WORKDIR/docker/* "/usr/local/bin"
}

function start_dockerd {
    echo "Starting dockerd"
    sudo dockerd -D
}

function cleanup {
    rm -rfv "$WORKDIR"
    sudo rm -rfv /usr/local/bin/docker*
}
