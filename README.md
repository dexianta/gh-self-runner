# Github runner

This repo composes of the docker image as well as the script to run github action runner on your own computer (amd64 or arm64)

## Workflow
`./start_worker.sh <runner name> <token (optional)>`\
when token is provided (can be obtained on github), `start_worker.sh` will setup a runner by downloading & configuring the runner's binary. Otherwise it starts the existing runner (assume one already exist, if following the normal work flow).

State files (`_work`) is persisted on the host machine (under `runners/` folder inside the repo root), and the container only serves as a runtime. Container runtime connects to the host machine via the following ways:
- share the docker daemon sock
- volume mounted to _work folder
- volume mounted to local go pkg folder
- etc (can be extended to other usecase, to acchieve more caching)

## Tips
Dealing with python version without using python base image can be challenging, it's recommended to invoke any work flow 
that you might have by runnign a separate docker process within(with a python base image, preferrably with all the dependency installed) for python specific task (testing python program etc), 
instead of using python interpreter directly

## Issue to solve
building on arm64 but pushing to amd64 environment

