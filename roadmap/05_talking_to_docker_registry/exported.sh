#!/bin/bash
export C05_CACHE="$(pwd)/../../cache/05"
export C05_GOROOT="$(pwd)/../../goroot"
export C05_GOPATH="$(pwd)/../../goworkspace"
export C05_GOLANG_TARBALL_URL="https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz"
export C05_GOLANG_TARBALL_LOCAL="$C05_CACHE/golang.tar.gz"
export C05_OLDPATH=""
export C05_DOCKER2CVMFS_IMPORT_PATH="github.com/cvmfs/docker2cvmfs/docker2cvmfs"

function f05_load_dependencies {
    . ../common.sh
}

function f05_install_golang {
    echo "Install golang"

    if [ ! -e "$C05_GOLANG_TARBALL_LOCAL" ]; then
        wget "$C05_GOLANG_TARBALL_URL" -O "$C05_GOLANG_TARBALL_LOCAL"
    else
        echo "Golang tarball already downloaded..."
    fi

    if [ ! -e "$C05_GOROOT/bin" ]; then
        tar xf "$C05_GOLANG_TARBALL_LOCAL" -C "$WORKDIR"
        mv $WORKDIR/go/* "$C05_GOROOT"
    fi
}

function f05_setup_golang_env {
    f05_install_golang

    export C05_OLDPATH="$PATH"

    export GOPATH="$C05_GOPATH"
    export GOROOT="$C05_GOROOT"
    export PATH="$C05_GOPATH/bin:$C05_GOROOT/bin:$C05_OLDPATH"
}

function f05_get_docker2cvmfs_tool {
    go get "$C05_DOCKER2CVMFS_IMPORT_PATH"
}

function f05_test_1 {
    echo "run test 1"
}

function f05_cleanup {
    rm -rf "$WORKDIR"
    export PATH="$C05_OLDPATH"
    export GOROOT=""
    export GOPATH=""
}
