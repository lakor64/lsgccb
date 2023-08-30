#!/bin/bash

# mingw64 download and extract

run_stage()
{
    download_file https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v${mingw_version}.tar.bz2/download mingw-w64-v${mingw_version}.tar.bz2
    extract_tar mingw-w64-v${mingw_version}.tar.bz2 mingw-w64-v${mingw_version}

    cd $blddir/$target/$stage/

    if ! [[ -e Makefile ]] ; then
        "${distdir}mingw-w64-v${mingw_version}/configure" \
            --prefix="${bindir}${target}/" \
            --target="$triplet" \
            --with-sysroot="${bindir}${target}" \
            ${mingw_extra}
    fi
    make all -j$cpucount
    make install
}

