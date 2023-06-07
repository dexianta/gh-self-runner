#!/bin/bash
name=$1
token=$2

docker kill $name; docker rm $name
set -e
arch=$(uname -m | sed 's/x86_64/x64/')
git_root=$(git rev-parse --show-toplevel)
dir="$git_root/runners/$name"
echo "$dir"

bin_dir="$git_root/runner-bin"

if [ ! -d $bin_dir ]; then 
  mkdir $bin_dir
fi

if [ -z "$(ls -l $bin_dir)" ]; then 
  echo "bin not found, downloading..."
  cd $bin_dir
  if [ "$arch" == 'x64' ]; then
    curl -o bin.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-x64-2.304.0.tar.gz
  else
    echo "unsupported arch: $arch"
    exit 1
  fi
fi

# if token is not empty, that mean we want to setup a new folder
if [ -n "$token" ]; then
  rm -rf "$dir/*"
  mkdir -p $dir
  tar xzf $bin_dir/bin.tar.gz -C $dir
fi


echo "-------- building image ----------"
cd $git_root
if [ "$arch" = 'x64' ]; then
  echo 'building for amd64...'
  docker build --platform linux/amd64 --build-arg='arch=x64' -t runner:latest -f Dockerfile .
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
