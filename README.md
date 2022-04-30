# Github runner

This repo composes of the docker image as well as the script to run github action runner on our own computer

## Workflow
- 1) Prepare the worker environment by `./prepare_worker.sh <suffix_of_worker> <runner_token_from_github>`
- 2) `./start_container.sh <runner_suffix>`

e.g. `./prepare_worker.sh 101 XXXXXXXX`, `./start_container.sh 101`. this will create a worker with the name of `runner-101`

# Python builds
For Python builds, we use Python 3.8.x and openjdk-11 (which is needed for pyspark and should be configured as the default).
