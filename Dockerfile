FROM ubuntu:latest

ARG APP_VERSION=v6.0.0-beta
ARG CPUS=1

RUN apt-get update &&\
    apt-get install -y git automake autoconf libtool libxml2-dev libxslt-dev libsnmp-dev qt5-default qttools5-dev-tools adduser &&\
    rm -rf /var/lib/apt/lists/*

RUN adduser --home /home/fwbuilder fwbuilder

RUN git clone https://github.com/fwbuilder/fwbuilder.git /fwbuilder

WORKDIR /fwbuilder
RUN git checkout $APP_VERSION

RUN ./autogen.sh &&\
    make -j${CPUS} &&\
    make -j${CPUS} install

WORKDIR /home/fwbuilder
RUN rm -rf /fwbuilder
USER fwbuilder

CMD ["/usr/local/bin/fwbuilder"]