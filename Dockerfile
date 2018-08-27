FROM ubuntu:latest as builder

ARG APP_VERSION=v6.0.0-beta
ARG CPUS=1

RUN apt-get update &&\
    apt-get install -y git automake autoconf libtool libxml2-dev libxslt-dev libsnmp-dev qt5-default qttools5-dev-tools checkinstall &&\
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/fwbuilder/fwbuilder.git /fwbuilder

WORKDIR /fwbuilder
RUN git checkout $APP_VERSION

RUN ./autogen.sh &&\
    make -j${CPUS}

# dirty solutions
RUN checkinstall --install=no --maintainer="Rafael Chicoli" --pkgname=fwbuilder --pkgversion=6.0.0-beta --backup=no --fstrans=no -y &&\
    rm /fwbuilder/fwbuilder_6.0.0-beta-1_amd64.deb
RUN checkinstall --install=no --maintainer="Rafael Chicoli" --pkgname=fwbuilder --pkgversion=6.0.0-beta --backup=no --fstrans=yes --requires=libxml2,libxslt1.1,libsnmp30,libqt5printsupport5 -y


FROM ubuntu:latest

COPY --from=builder /fwbuilder/fwbuilder_6.0.0-beta-1_amd64.deb /

RUN apt-get update &&\
    apt-get install -y --no-install-recommends libxml2 libxslt1.1 libsnmp30 libqt5printsupport5 &&\
    rm -rf /var/lib/apt/lists/*

RUN dpkg -i /fwbuilder_6.0.0-beta-1_amd64.deb &&\
    rm /fwbuilder_6.0.0-beta-1_amd64.deb

RUN useradd -m -d /home/fwbuilder fwbuilder

USER fwbuilder
WORKDIR /home/fwbuilder
CMD ["/usr/local/bin/fwbuilder"]