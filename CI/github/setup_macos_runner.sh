#!/bin/bash

set -e
set -x

# OpenMP is not present on macOS by default
if [[ "$RUNNER_OS" == "macOS" ]]; then # this if is useless, but better be safe
    echo "Installing Mac OS dependencies"
	brew_prefix=$(brew --prefix)
    brew install libomp
    export CC=/usr/bin/clang
    export CXX=/usr/bin/clang++
    export CPPFLAGS="$CPPFLAGS -Xpreprocessor -fopenmp"
    export CFLAGS="$CFLAGS -I$brew_prefix/opt/libomp/include"
    export CXXFLAGS="$CXXFLAGS -I$brew_prefix/opt/libomp/include"
    export LDFLAGS="$LDFLAGS -Wl,-rpath,$brew_prefix/opt/libomp/lib -L$brew_prefix/opt/libomp/lib -lomp"
fi
