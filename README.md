# Github runner

This repo composes of the docker image as well as the script to run github action runner on our own computer

## Workflow
`./start_worker.sh <runner name> <token (optional)>`\
when token is provided, `start_worker.sh` will setup a runner by download & config the runner binary. Otherwise it starts the existing runner normally.\

It supports both arm64 and x64.

