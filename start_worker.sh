#!/bin/bash
suffix=$1
dir="$HOME/runners/runner-$suffix"
echo "$dir"

if [ -d "$dir" ]; then
	echo "valid runner"
else
	echo "invalid runner: $dir"
	exit 1
fi

echo "-------- building image ----------"
if [ $(uname) = 'Linux' ]; then
  docker build --platform linux/amd64 --build-arg='arch=Linux' -t runner:latest -f Dockerfile .
elif [ "$(uname)" = 'Darwin' ]; then
  docker build --platform linux/arm64 --build-arg='arch=Darwin' -t runner:latest -f Dockerfile .
else
  echo "invalid arch"
  exit 1
fi

echo "-------- runner container ----------"
docker run -v /var/run/docker.sock:/var/run/docker.sock \
	-v $HOME/go/pkg:/root/go/pkg \
	-v "$dir":/runner \
	--name $suffix \
	--network host \
	runner:latest 
