#!/bin/bash
name=$1
token=$2

docker kill $name; docker rm $name
set -e
arch=$(uname -m | sed 's/x86_64/x64/')
git_root=$(git rev-parse --show-toplevel)
dir="$git_root/runners/$name"
echo "$dir"

# if token is not empty, that mean we want to setup a new folder
if [ -n "$token" ]; then
  # download the binary
  echo "download runner binary at $dir"
   
  rm -rf "$dir/*"
  mkdir -p $dir
  cd $dir
  echo "== pwd: $(pwd)"
  if [ "$arch" == 'x64' ]; then
    curl -o actions-runner-linux-x64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-x64-2.304.0.tar.gz
    tar xzf ./actions-runner-linux-x64-2.304.0.tar.gz
  elif [ "$arch" == 'arm64' ]; then
    curl -o actions-runner-linux-arm64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-arm64-2.304.0.tar.gz
    tar xzf ./actions-runner-linux-arm64-2.304.0.tar.gz
  else
    echo "unknow arch: $arch"
    exit 1
  fi
fi


echo "-------- building image ----------"
cd $git_root
if [ "$arch" = 'x64' ]; then
  echo 'building for amd64...'
  docker build --platform linux/amd64 --build-arg='arch=x64' -t runner:latest -f Dockerfile .
elif [ "$arch" = 'arm64' ]; then
  echo 'building for arm64..'
  docker build --platform linux/arm64 --build-arg='arch=arm64' -t runner:latest -f Dockerfile .
else
  echo "invalid arch"
  exit 1
fi

echo "-------- runner container ----------"
if [ -n "$token" ]; then
  docker run \
    -e name=$name \
    -e token=$token \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/go/pkg:/root/go/pkg \
    -v "$dir":/runner \
    --name $name \
    --network host \
    runner:latest 
else
  docker run \
    -e name=$name \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/go/pkg:/root/go/pkg \
    -v "$dir":/runner \
    --name $name \
    --network host \
    runner:latest 
fi
