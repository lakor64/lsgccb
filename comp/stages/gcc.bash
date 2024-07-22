#!/bin/bash

stage_target="gcc-${gcc_version}"
target_dist="${dist_dir}${stage_target}/"

run_stage()
{
    download_file "https://ftp.gnu.org/gnu/gcc/${stage_target}/${stage_target}.tar.gz" "${stage_target}.tar.gz"
    extract_tar "${stage_target}.tar.gz"
    apply_patches

    cd "$build_dir/$target/$stage/" || exit 4

    if ! [[ -e Makefile ]] ; then
        if ! "${target_dist}/configure" \
            --prefix="${bin_dir}${target}/" \
            --target="$triplet" \
            --with-sysroot="${bin_dir}${target}" \
            --with-pkgversion="lakor's shitty! compilers builds" \
            --with-bugurl="https://github.com/lakor64/lsgccb" \
            --enable-languages=c,c++ \
            --disable-multilib \
            --disable-nls \
            --disable-werror \
			--disable-shared \
            "${gcc_extra}" ; then
				exit 2
		fi
    fi

    if ! make all -j"$cpucount" ; then
		exit 3
	fi
    
	if ! make install.all ; then
		exit 4
	fi
}
