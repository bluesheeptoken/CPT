#!/bin/bash

set -e
set -x

# OpenMP is not present on macOS by default
if [[ "$RUNNER_OS" == "macOS" ]]; then
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

python -m pip install cibuildwheel==3.1.1
python -m cibuildwheel --print-build-identifiers
python -m cibuildwheel --output-dir wheelhouse
