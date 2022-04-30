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

curl -o actions-runner-linux-x64-2.290.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.290.1/actions-runner-linux-x64-2.290.1.tar.gz
echo "2b97bd3f4639a5df6223d7ce728a611a4cbddea9622c1837967c83c86ebb2baa  actions-runner-linux-x64-2.290.1.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.290.1.tar.gz
./config.sh --url https://github.com/benshi-ai --token AN5B6KN35ZRGLI5XBWOA7V3CNUKES --name runner-"$runner_suffix" --labels self-hosted --runnergroup default --replace
