#!/bin/bash
set -e

runner_suffix=$1
token=$2
if [ -z "$runner_suffix" ]; then
	echo "suffix not provided"
	exit 0
fi

path=$HOME/runners/runner-"$runner_suffix"
rm -rf $path
mkdir -p $path
cd $path

arch=$(uname)

if [ "$arch" == 'Linux' ]; then
  curl -o actions-runner-linux-x64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-x64-2.304.0.tar.gz
  tar xzf ./actions-runner-linux-x64-2.304.0.tar.gz
elif [ "$arch" == 'Darwin' ]; then
  curl -o actions-runner-osx-arm64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-osx-arm64-2.304.0.tar.gz
  tar xzf ./actions-runner-osx-arm64-2.304.0.tar.gz
else
  echo "unknow arch: $arch"
  exit 1
fi


./config.sh --unattended \
  --url https://github.com/causalfoundry \
  --token $token \
  --name runner-"$runner_suffix" \
  --labels 'self-hosted,backend,frontend' \
  --work _work \
  --runnergroup default \
  --replace
