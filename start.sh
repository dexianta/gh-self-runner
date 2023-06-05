#!/bin/bash
export PYENV_ROOT="/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
pyenv activate runner

export PATH=$HOME/go/bin:$PATH

cd /runner && ./run.sh
