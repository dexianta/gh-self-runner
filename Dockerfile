FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y ca-certificates curl gnupg lsb-release build-essential \
    && apt-get install -y docker.io wget \
    && rm -rf /var/lib/apt/lists/*


######################
## golang 1.17
######################
RUN wget https://go.dev/dl/go1.17.9.linux-amd64.tar.gz \
	&& rm -rf /usr/local/go \
	&& tar -C /usr/local -xzf go1.17.9.linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:$HOME/go/bin

RUN go install github.com/swaggo/swag/cmd/swag@latest



######################
## open jdk 11
######################
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless && \
    apt-get clean;



######################
## pyenv 3.8.x
######################
ARG PYTHON_VERSION=3.8.12 ENV_NAME=benshi

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 PYENV_ROOT=/.pyenv \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing && apt-get install -y bzip2 ca-certificates curl git make build-essential \
    libssl-dev zlib1g-dev libbz2-dev \
    wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libreadline-dev \
    libsqlite3-dev tzdata && apt-get clean

# pyenv
RUN git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT && \
    cd $PYENV_ROOT && git pull && src/configure && make -C src

# pyenv-virtualenv
RUN git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv

ENV PATH=$PYENV_ROOT/bin:$PATH
RUN echo $PATH

COPY requirements.txt .

RUN eval "$(pyenv init --path)" && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && \
    pyenv install $PYTHON_VERSION && pyenv virtualenv $PYTHON_VERSION benshi && pyenv activate benshi && \
    pip install --upgrade pip && pip install -r requirements.txt

######################
## entrypoint
######################
USER root

COPY start.sh .
RUN chmod u+x start.sh 
RUN mkdir -p /runner

ENV RUNNER_ALLOW_RUNASROOT 1


ENTRYPOINT ["./start.sh"]

