# runner_script

This script is to setup a machine as self-hosted github action runner for Linux machine

# Get started
To set up a runner, first build the image, then run the image with 2 parameters, first one is the suffix of the runner, second is the token from github. e.g.

`docker build -t runner:latest -f Dockerfile .`  
`docker run -v /var/run/docker.sock:/var/run/docker.sock --network="host" runner:<tag> <runner_suffix> <token>`

# Python builds

For Python builds, we use Python 3.8.x and openjdk-11 (which is needed for pyspark and should be configured as the default).
