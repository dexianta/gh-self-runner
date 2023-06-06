FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y ca-certificates curl gnupg lsb-release build-essential \
    && apt-get install -y docker.io wget \
    && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND noninteractive

ARG token
ARG arch
ENV arch=$arch
######################
## golang
######################
RUN if [ "$arch" = 'x64' ]; then \
        wget https://go.dev/dl/go1.20.4.linux-amd64.tar.gz \
        && rm -rf /usr/local/go \
        && tar -C /usr/local -xzf go1.20.4.linux-amd64.tar.gz; \
    elif [ "$arch" = 'arm64' ]; then \
        wget https://go.dev/dl/go1.20.4.linux-arm64.tar.gz \
        && rm -rf /usr/local/go \
        && tar -C /usr/local -xzf go1.20.4.linux-arm64.tar.gz; \
    else \
      echo "invalid arch";\
      exit 1;\
    fi

ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:$HOME/go/bin

RUN go version

RUN apt-get update --fix-missing && \
    apt-get install -y sudo bzip2 ca-certificates curl git jq make build-essential postgresql-client tcl \
    libssl-dev zlib1g-dev libbz2-dev nodejs \
    wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libreadline-dev \
    libsqlite3-dev tzdata && \
    apt-get clean


######################
## misc
######################
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

######################
## entrypoint
######################
USER root

COPY start.sh .
RUN chmod u+x start.sh 
RUN mkdir -p /runner # mount to the host machine's runner state files

ENV RUNNER_ALLOW_RUNASROOT 1


ENTRYPOINT ["./start.sh"]

