#!/bin/bash
set -e
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
