#!/bin/bash
#random utilities

download_file()
{
    if ! [[ -e "${distdir}$2" ]] ; then
        echo Downloading $2...
        wget -q -O ${distdir}$2 $1
    fi
}

extract_tar()
{
    if ! [[ -e "${distdir}${2}" ]] ; then
        echo Extracting $1...
        mkdir -p "${distdir}$2"
        tar -C "${distdir}" -xf "${distdir}${1}"
    fi
}
