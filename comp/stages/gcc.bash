#!/bin/bash

# gcc download and extract

run_stage()
{
    download_file https://ftp.gnu.org/gnu/gcc/gcc-${gcc_version}/gcc-${gcc_version}.tar.gz gcc-${gcc_version}.tar.gz
    extract_tar gcc-${gcc_version}.tar.gz gcc-${gcc_version}

    cd $blddir/$target/$stage/

    if ! [[ -e Makefile ]] ; then
        if ! [[ "${distdir}gcc-${gcc_version}/configure" \
            --prefix="${bindir}${target}/" \
            --target="$triplet" \
            --with-sysroot="${bindir}${target}" \
            --with-pkgversion="lakor's shitty gcc builds" \
            --with-bugurl="https://github.com/lakor64/lsgccb" \
            --enable-languages=c,c++ \
            --disable-multilib \
            --disable-nls \
            --disable-werror \
			--disable-shared \
            ${gcc_extra} ]]; then
				exit 2
		fi
			
    fi
    if ! [[ make all -j$cpucount ]]; then
		exit 3
	fi
	if ! [[ make install.all ]]; then
		exit 4
	fi
}
