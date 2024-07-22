#!/bin/bash
# mingw64 crt

stage_target="mingw-w64-${mingw_version}"
target_dist="${dist_dir}${stage_target}/"

run_stage()
{
    download_file "https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v${mingw_version}.tar.bz2/download" "mingw-w64-v${mingw_version}.tar.bz2"
    extract_tar "mingw-w64-v${mingw_version}.tar.bz2"

    cd "$build_dir/$target/$stage/"

    if ! [[ -e Makefile ]] ; then
        if ! "${target_dist}/configure" \
            --prefix="${bin_dir}${target}/" \
            --target="$triplet" \
            --with-sysroot="${bin_dir}${target}" \
            "${mingw_extra}" ; then
				  exit 2
		    fi
    fi

    if make all -j$cpucount ; then
		    exit 3
	  fi
    
    if make install ; then
		    exit 4
	  fi
}

