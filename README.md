# How to install OPM on macOS

## Prerequisites

- **macOS** on Apple Silicon
- **Xcode Command Line Tools**: `xcode-select --install`
- Install required packages:
  ```bash
  brew install cmake boost open-mpi pkg-config fmt suite-sparse
  ```

## Build steps

All scripts are designed to be run from the repository root directory.

You can override the install prefix and parallelism via environment variables:
```bash
export INSTALL_PREFIX=/your/preferred/path  # default: ./local
export PARALLEL_JOBS=8                       # default: 6
```

### 1. Build DUNE modules

```bash
./build_dune.sh
```

### 2. Build Zoltan (from Trilinos)

```bash
./install_zoltan.sh
```

### 3. Build OPM

```bash
./install_opm.sh
```

## Running simulations

Run `flow` directly:
```bash
./opm-simulators/build/bin/flow MY_DECK.DATA
```

Run in parallel using MPI:
```bash
mpirun -np 4 ./opm-simulators/build/bin/flow MY_DECK.DATA --output-dir=out_parallel
```

## ERT integration

Add `flow` to your `PATH` so ERT can find it:
```bash
export PATH="/path/to/install-opm-mac/opm-simulators/build/bin:$PATH"
```