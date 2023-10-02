#!/bin/bash

# binutils download and extract

run_stage()
{
    download_file https://ftp.gnu.org/gnu/binutils/binutils-${binutils_version}.tar.gz binutils-${binutils_version}.tar.gz
    extract_tar binutils-${binutils_version}.tar.gz binutils-${binutils_version}

    cd $blddir/$target/$stage/

    if ! [[ -e Makefile ]] ; then
        if ! "${distdir}binutils-${binutils_version}/configure" \
            --prefix="${bindir}${target}/" \
            --target="$triplet" \
            --with-sysroot="${bindir}${target}" \
            --with-pkgversion="lakor's shitty gcc builds" \
            --with-bugurl="https://github.com/lakor64/lsgccb" \
            --disable-multilib \
            --disable-werror \
            --enable-lto \
            --enable-plugins \
            --with-zlib=yes \
            --disable-nls \
			${binutils_extra} ; then
			exit 2
		fi
	fi
	if ! make all -j$cpucount; then
		exit 3
	fi
    if ! make install; then
		exit 4
	fi
}
