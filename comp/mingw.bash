#!/bin/bash

mingw_version="12.0.0"
binutils_version="2.42"
gcc_version="14.1.0"

gcc_extra="--disable-win32-registry \
		--enable-sjlj-exceptions \
		--disable-libstdcxx-verbose \
		--enable-threads=win32 \
		--enable-tls \
		--enable-fully-dynamic-string \
		--enable-version-specific-runtime-libs"
