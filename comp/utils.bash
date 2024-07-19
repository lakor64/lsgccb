#!/bin/bash
#random utilities

download_file()
{
    if ! [[ -e "${distdir}${2}" ]] ; then
        echo Downloading $2...
        wget -q -O ${distdir}$2 $1
    fi
}

extract_tar()
{
    if ! [[ -e "${distdir}${2}" ]] ; then
        echo Extracting $1...
        mkdir -p "${distdir}${2}"
        tar -C "${distdir}" -xf "${distdir}${1}"
    fi
}

apply_patches()
{
    if [[ -e "${patchdir}${1}" ]] ; then
        if ! [[ -e "${distdir}${1}.patched" ]] ; then
            for entry in "${patchdir}${1}"/*.patch
            do
                entry_name=${entry%.patch*}
                entry_name=${entry_name#*${patchdir}${1}/}
                echo Patch: $entry_name...
                if ! patch -p0 -N -d "${distdir}${1}" < "${entry}" ; then
                    echo Failed to apply patch
                    exit 3
                fi
            done
            echo "OK" > ${distdir}${1}.patched
        fi
    fi
}