#!/bin/bash
export PYENV_ROOT="/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
pyenv activate runner

export PATH=$HOME/go/bin:$PATH

if [ -z $token ]; then
  cd /runner && ./run.sh
else
  cd /runner 
  ./config.sh --unattended \
    --url https://github.com/causalfoundry \
    --token $token \
    --name "$name" \
    --labels 'self-hosted,backend,frontend' \
    --work _work \
    --runnergroup default \
    --replace
  ./run.sh
fi
