#!/bin/bash
runner_name=$1
token=$2

echo "starting runner"
echo "runner_name: $runner_name"
echo "token: $token"

mkdir runner-"$runner_name" && cd runner-"$runner_name"

curl -o actions-runner-linux-x64-2.290.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.290.1/actions-runner-linux-x64-2.290.1.tar.gz
echo "2b97bd3f4639a5df6223d7ce728a611a4cbddea9622c1837967c83c86ebb2baa  actions-runner-linux-x64-2.290.1.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.290.1.tar.gz

# more steps need to be taken here
./config.sh --url https://github.com/benshi-ai --token $2 --work _work --name ${PWD##*/} --labels self-hosted --runnergroup default --replace

./run.sh

