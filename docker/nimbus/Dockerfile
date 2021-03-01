FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
      build-essential \
      git \
      libpcre3-dev

ADD https://api.github.com/repos/status-im/nimbus-eth2/git/refs/heads/stable version.json

RUN git clone \
      --depth 1 \
      -b stable \
      https://github.com/status-im/nimbus-eth2 \
      /nimbus

COPY ./build-nimbus.sh /nimbus/

WORKDIR /nimbus

CMD "./build-nimbus.sh"
