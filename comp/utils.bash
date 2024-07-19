#!/bin/bash


## global vars:
# target_dist: output extracted directory
# cache_dir: directory to store cached operations
# patch_dir: directory where the patches are found
# stage_target: target file name with version to apply patch/dist
# dist_dir: directory where all the distributions are stored

# Downloads a file
# Argument 1: URL where to download the file
# Argument 2: File name to save

download_file()
{
    if ! [[ -e "$tar_dir$2" ]] ; then
        echo "Downloading $2..."
        wget -q -O "$tar_dir$2" "$1"
    fi
}

extract_tar()
{
    if ! [[ -e "$target_dist" ]] ; then
        echo "Extracting $1..."
        mkdir -p "$target_dist"
        tar -C "$dist_dir" -xf "$tar_dir$1"
    fi
}

apply_patches()
{
    if [[ -e "${patch_dir}${stage_target}" ]] ; then
        if ! [[ -e "${cache_dir}patched" ]] ; then
            for entry in "${patch_dir}${stage_target}"/*.patch
            do
                entry_name=${entry%.patch*}
                entry_name=${entry_name#*"${patch_dir}${1}/"}
                echo "Patch: $entry_name..."
                if ! patch -p0 -N -d "${target_dist}" < "${entry}" ; then
                    echo Failed to apply patch
                    exit 3
                fi
            done
            echo "OK" > "${cache_dir}patched"
        fi
    fi
}

run_autoconf()
{
    if ! [[ -e "${cache_dir}autoconf" ]] ; then
        cd "${target_dist}" || exit 2
        autoreconf -f
        echo "OK" > "${cache_dir}autoconf"
    fi
}
