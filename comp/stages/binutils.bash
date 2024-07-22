#!/bin/bash

stage_target="binutils-${binutils_version}"
target_dist="${dist_dir}${stage_target}/"

run_stage()
{
    download_file "https://ftp.gnu.org/gnu/binutils/${stage_target}.tar.gz" "binutils-${binutils_version}.tar.gz"
    extract_tar "${stage_target}.tar.gz"
    apply_patches

    if ! [[ -e "${cache_dir}bfdconf" ]] ; then
        cd "${target_dist}bfd" || exit 4
        autoconf
        echo "OK" > "${cache_dir}bfdconf"
    fi

    cd "$build_dir/$target/$stage/" || exit 4

    if ! [[ -e Makefile ]] ; then
        if ! "${target_dist}/configure" \
            --prefix="${bin_dir}${target}/" \
            --target="$triplet" \
            --with-sysroot="${bin_dir}${target}" \
            --with-pkgversion="lakor's shitty! compilers builds" \
            --with-bugurl="https://github.com/lakor64/lsgccb" \
            --disable-multilib \
            --disable-werror \
            --enable-lto \
            --enable-plugins \
            --with-zlib=yes \
            --disable-nls \
			"${binutils_extra}" ; then
			exit 2
		fi
	fi

	if ! make all -j"$cpucount"; then
		exit 3
	fi
    
    if ! make install; then
		exit 4
	fi
}
