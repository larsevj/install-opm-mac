#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# Edit the next two variables to match your wishes and system.
install_prefix="${INSTALL_PREFIX:-$SCRIPT_DIR/local}"
parallel_build_tasks="${PARALLEL_JOBS:-6}"

# Set of modules to build
modules="dune-common dune-geometry dune-grid dune-istl"

cd "$SCRIPT_DIR"

# Clone modules, check out the 2.11 release.
for m in $modules; do
    echo "==================================================="
    echo "=        Cloning module: $m"
    echo "==================================================="
    (
        if [ ! -d "$m" ]; then
            git clone -b releases/2.11 https://gitlab.dune-project.org/core/$m.git
        else
            echo "******** Skipping $m, module already cloned."
        fi
    )
done

# Build the modules, and install them to the chosen directory
for m in $modules; do
    echo "==================================================="
    echo "=        Building module: $m"
    echo "==================================================="
    (
        cd $m
        builddir="build-cmake"
        if [ ! -d "$builddir" ]; then
            mkdir "$builddir"
            cd "$builddir"
            cmake -DCMAKE_INSTALL_PREFIX="$install_prefix" \
                  -DDUNE_ENABLE_PYTHONBINDINGS=OFF ".."
            make -j "$parallel_build_tasks"
            make install
        else
            echo "******** Skipping $m, build dir $builddir already exists."
        fi
    )
done
