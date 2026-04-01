#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Configuration — override via environment variables if needed.
install_prefix="${INSTALL_PREFIX:-$SCRIPT_DIR/local}"
parallel_build_tasks="${PARALLEL_JOBS:-6}"

BREW_PREFIX=/opt/homebrew

cd "$SCRIPT_DIR"

for repo in opm-common opm-grid opm-simulators opm-upscaling
do
    echo "=== Cloning and building module: $repo"

    if [ ! -d "$repo" ]; then
        git clone https://github.com/OPM/$repo.git
    else
        echo "******** Skipping clone of $repo, directory already exists."
    fi

    mkdir -p "$repo/build"
    cd "$repo/build"
    cmake -DCMAKE_PREFIX_PATH="$install_prefix;$BREW_PREFIX" \
          -DBOOST_INCLUDEDIR="$BREW_PREFIX/include" \
          -DCMAKE_CXX_FLAGS="-I$BREW_PREFIX/include" \
          -DUSE_OPENCL=OFF \
          -DZOLTAN_LIBRARY="$SCRIPT_DIR/Trilinos/build/packages/zoltan/src/libzoltan.a" \
          -DZOLTAN_INCLUDE_DIR="$SCRIPT_DIR/Trilinos/packages/zoltan/src/include;$SCRIPT_DIR/Trilinos/build/packages/zoltan/src" ..
    make -j "$parallel_build_tasks"
    cd ../..
done
