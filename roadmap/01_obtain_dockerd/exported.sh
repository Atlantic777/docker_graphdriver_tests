#!/bin/bash
C1_CACHE="../../cache/01"
C1_DOWNLOAD_URL="https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz"
C1_DOCKER_ARCHIVE_OUT="$C1_CACHE/docker-latest.tgz"

function f01_load_dependencies {
    . ../common.sh
}

function download_binary {
    echo "Downloading binary to $WORKDIR"

    wget "$C1_DOWNLOAD_URL" -O "$WORKDIR/$C1_DOCKER_ARCHIVE_OUT"
    tar xvf "$WORKDIR/$C1_DOCKER_ARCHIVE_OUT" -C "$WORKDIR"
    sudo cp -v $WORKDIR/docker/* "/usr/local/bin"
}

function f01_download_binary {
    if [ ! -f "$C1_DOCKER_ARCHIVE_OUT" ]; then
       wget "$C1_DOWNLOAD_URL" -O "$C1_DOCKER_ARCHIVE_OUT"
    fi
}

function f01_extract_binary {
    tar xvf "$C1_DOCKER_ARCHIVE_OUT" -C "$WORKDIR"
    sudo cp -v $WORKDIR/docker/* "/usr/local/bin"
}

function f01_install_docker {
    f01_download_binary
    f01_extract_binary
}

function start_dockerd {
    echo "Starting dockerd"
    sudo dockerd -D
}

function f01_start_dockerd {
    sudo dockerd -D
}

function cleanup {
    rm -rfv "$WORKDIR"
    sudo rm -rfv /usr/local/bin/docker*
}
