#!/bin/bash

# Ref: https://docs.conda.io/projects/miniconda/en/latest/index.html#quick-command-line-install
# Run with: ./miniconda.sh &
set -e                

# SET CONFIG
CONDA_URL="https://repo.continuum.io/miniconda/"
CONDA_DIR="$HOME/miniconda3"
CONDA_VERSION_SH="Miniconda3-latest-Linux-x86_64.sh"

# INSTALLATION
cd "$HOME"
mkdir -p "$CONDA_DIR"
# Download and install .sh
wget "$CONDA_URL/$CONDA_VERSION_SH" -O "$CONDA_DIR/miniconda.sh"
bash "$CONDA_DIR/miniconda.sh" -b -u -p "$CONDA_DIR"
# Cleanup
rm -rf "$CONDA_DIR/miniconda.sh"
# Initialize for zsh
"$CONDA_DIR/bin/conda" init zsh





