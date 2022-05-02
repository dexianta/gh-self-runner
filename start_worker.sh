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
docker build -t runner:latest -f Dockerfile .
echo "-------- runner container ----------"
docker run -v /var/run/docker.sock:/var/run/docker.sock \
	-v $HOME/go/pkg:/root/go/pkg \
	-v "$dir":/runner \
	--name $suffix \
	--network host \
	runner:latest 
