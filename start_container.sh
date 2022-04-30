#!/bin/bash
runner=$1
dir="$HOME/runners/$runner"
echo "$dir"

if [ -d "$dir" ]; then
	echo "valid runner"
else
	echo "invalid runner"
	exit 1
fi

echo "-------- building image ----------"
docker build -t runner:latest -f Dockerfile .
echo "-------- runner container ----------"
docker run -v /var/run/docker.sock:/var/run/docker.sock \
	-v $HOME/go/pkg:/root/go/pkg \
	-v "$dir":/runner \
	--network host \
	runner:latest 
