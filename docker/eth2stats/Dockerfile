FROM ubuntu:20.04

RUN apt-get update && apt-get install -y wget git make && \
    wget https://golang.org/dl/go1.15.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.15.linux-amd64.tar.gz

ADD https://api.github.com/repos/Alethio/eth2stats-client/git/refs/heads/master version.json

RUN git clone https://github.com/Alethio/eth2stats-client.git /eth2stats

COPY ./build-eth2stats.sh /eth2stats/

WORKDIR /eth2stats

CMD "./build-eth2stats.sh"
