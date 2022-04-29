FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y ca-certificates curl gnupg lsb-release build-essential \
    && apt-get install -y docker.io \
    && rm -rf /var/lib/apt/lists/*


## miniconda 3.8
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.11.0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

## golang 1.17
RUN wget https://go.dev/dl/go1.17.9.linux-amd64.tar.gz \
	&& rm -rf /usr/local/go \
	&& tar -C /usr/local -xzf go1.17.9.linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY start.sh .
ENTRYPOINT ./start.sh

