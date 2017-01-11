#!/bin/bash

function get_repositories_json {
    sudo jq . /var/lib/docker/image/aufs/repositories.json
}

function get_distribution_files {
    sudo find /var/lib/docker/image/aufs/distribution -type f
}

function get_imagedb_files {
    sudo find /var/lib/docker/image/aufs/imagedb -type f
}

function get_layerdb_files {
    sudo find /var/lib/docker/image/aufs/layerdb -type f
}

function pull_ubuntu {
    docker pull library/ubuntu:16.04
}

function get_image_hash {
    local tag="$1"
    get_repositories_json | jq ".Repositories[][\"$tag\"]"
}

function get_local_config {
    local tag="$1"
    local image_hash=`get_image_hash $tag`
    local image_hash_raw=`echo $image_hash | sed "s/.*:\(.*\)\"/\\1/"`
    local config_filepath=`get_imagedb_files | grep $image_hash_raw`

    sudo jq . "$config_filepath"
}

function get_diffids {
    local tag="$1"
    get_local_config "$tag" | jq .rootfs.diff_ids
}

function get_digests {
    local tag="$1"

    for digest in $(get_diffids "$tag" | jq .[]); do
        v2metadata_by_diffid "$digest" | jq .[0].Digest
    done
}

function get_hash_type {
    local hash="$1"
    echo "$hash" | sed "s/\"\?\(\w*\):\(\w*\)\"\?/\1/"
}

function get_hash_value {
    local hash="$1"
    echo "$hash" | sed "s/\"\?\(\w*\):\(\w*\)\"\?/\2/"
}

function diffid_by_digest {
    local digest="$1"
}

function v2metadata_by_diffid {
    local diffid="$1"
    local prefix="/var/lib/docker/image/aufs/distribution/v2metadata-by-diffid/"
    local p="$prefix/$(get_hash_type $diffid)/$(get_hash_value $diffid)"
    sudo jq . "$p"
}

function merge_diffids_to_chainid {
    local a="$1"
    local b="$2"
    local c=`echo -n $1 $2 | sed "s/\"//g"`

    # note -n flag, don't add \n add the end of the string
    echo -n "$c" | sha256sum | sed "s/\(\w*\).*/\"sha256:\1\"/"
}

function get_chainids_ {
    local tag="$1"
    local chainid=$(get_diffids "$tag" | jq .[0])
    echo "$chainid"

    for digest in $(get_diffids "$tag" | jq .[1:][]); do
        chainid=`merge_diffids_to_chainid $chainid $digest`
        echo "$chainid"
    done
}

function get_chainids {
    local raw=`get_chainids_ $1 $2`
    echo "$raw" | jq --slurp .
}

function get_cacheids_ {
    local tag="$1"
    local chainids="`get_chainids $tag | jq .[]`"

    while read -r id; do
        local type=`get_hash_type $id`
        local value=`get_hash_value $id`
        local p="/var/lib/docker/image/aufs/layerdb/$type/$value/cache-id"
        local c=`sudo cat "$p"`
        echo "\"sha256:$c\""
    done <<< "$chainids"
}

function get_cacheids {
    local tag="$1"
    get_cacheids_ $tag | jq --slurp .
}

function test_1 {
    echo "test 1"
    # clean repo
    # repositories.json is empty
    # no files in imagedb, layerdb and distribution
}

function test_2 {
    echo "test 2"
    # after pull
    # an entry in repositories.json for given tag
    # config file exists
    # all diffids from config exist in distribution/metadata
    # all diffids from config match diffids from distribution/diffid-by-digest
    # generate chainids and look them up in the layerdb
    # check if all cacheids exist in aufs/diff
}

function test_3 {
    echo "test 3"
    # after create
    # lookup for container config
    # check the -init layer (the rw layer)
}

function test_4 {
    echo "test 4"
    # after start
    # check the mountpoints
}
