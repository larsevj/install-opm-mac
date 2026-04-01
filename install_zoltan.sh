#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

parallel_build_tasks="${PARALLEL_JOBS:-6}"

BREW_PREFIX=/opt/homebrew

cd "$SCRIPT_DIR"

if [ ! -d "Trilinos" ]; then
    git clone https://github.com/trilinos/Trilinos.git
fi

cd Trilinos
git checkout trilinos-release-17-0-0 2>/dev/null || true

if [ ! -d "build" ]; then
    mkdir build
fi

(
  cd build
  cmake \
    -D TPL_ENABLE_MPI:BOOL=ON \
    -D MPI_BASE_DIR:PATH="$BREW_PREFIX" \
    -D Trilinos_ENABLE_ALL_PACKAGES:BOOL=OFF \
    -D Trilinos_ENABLE_Zoltan:BOOL=ON \
    ../
  make -j "$parallel_build_tasks"
)
