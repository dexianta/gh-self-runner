FROM ubuntu:latest

USER root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing 
RUN apt-get install -y ca-certificates sudo git jq make curl gnupg postgresql-client lsb-release build-essential 
RUN curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN apt-get install -y nodejs tzdata docker.io wget libicu-dev libsecret-1-dev


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


######################
## node
######################
ENV NVM_DIR /root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash 
RUN . "$NVM_DIR/nvm.sh" && nvm install 20
RUN node -v


######################
## misc
######################
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
# binary will be $(go env GOPATH)/bin/golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/go/bin v1.53.3 && golangci-lint --version



######################
## entrypoint
######################
COPY start.sh .
RUN chmod u+x start.sh 
RUN mkdir -p /runner # mount to the host machine's runner state files

ENV RUNNER_ALLOW_RUNASROOT 1


ENTRYPOINT ["./start.sh"]

