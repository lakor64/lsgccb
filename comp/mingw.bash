#!/bin/bash

mingw_version="11.0.1"
binutils_version="2.41"
gcc_version="13.2.0"

default_stages=(binutils mingw gcc mingw-crt)

gcc_extra="--disable-win32-registry \
		--enable-sjlj-exceptions \
		--disable-libstdcxx-verbose \
		--enable-threads=win32 \
		--enable-tls \
		--enable-fully-dynamic-string \
		--enable-version-specific-runtime-libs"
